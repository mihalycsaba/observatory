import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:observatory/settings/settings_repository.dart';
import 'package:observatory/auth/state/steam_state.dart';
import 'package:observatory/shared/constans.dart';
import 'package:observatory/shared/api/parsers.dart';
import 'package:observatory/shared/models/deal.dart';
import 'package:observatory/shared/models/history.dart';
import 'package:observatory/shared/models/info.dart';
import 'package:observatory/shared/models/itad_filters.dart';
import 'package:observatory/shared/models/overview.dart';
import 'package:observatory/shared/models/price.dart';
import 'package:observatory/shared/models/store.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class API {
  final Dio dio;
  final CacheOptions cacheOptions;
  final SettingsRepository settingsReporsitory = GetIt.I<SettingsRepository>();

  API({
    required this.dio,
    required this.cacheOptions,
  });

  static API create(String? directory) {
    final options = CacheOptions(
      store: HiveCacheStore(directory),
      policy: CachePolicy.noCache,
      maxStale: const Duration(days: 14),
    );

    return API(
      dio: Dio(BaseOptions(responseType: ResponseType.plain))
        ..interceptors.add(DioCacheInterceptor(options: options)),
      cacheOptions: options,
    );
  }

  Future<Info?> info({
    required String id,
  }) async {
    try {
      final Uri url = Uri.https(BASE_URL, '/games/info/v2', {
        'key': API_KEY,
        'id': id,
      });

      return Parsers.info(await dio.get(url.toString()));
    } catch (error, stackTrace) {
      Logger().e(
        'Failed to fetch info',
        error: error,
      );

      Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  Future<Overview?> overview({
    required List<String> ids,
  }) async {
    final String country = await settingsReporsitory.getCountry();

    try {
      final Uri url = Uri.https(BASE_URL, '/games/overview/v2', {
        'key': API_KEY,
        'country': country,
      });

      final response = await dio.post(
        url.toString(),
        data: json.encode(ids),
      );

      return Parsers.overview(response);
    } catch (error, stackTrace) {
      Logger().e(
        'Failed to fetch overview',
        error: error,
      );

      Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  Future<Map<String, List<Price>?>> prices({
    required List<String> ids,
  }) async {
    final String country = await settingsReporsitory.getCountry();
    final List<int> stores = await settingsReporsitory.getSelectedStores();

    try {
      final FunctionResponse prices =
          await Supabase.instance.client.functions.invoke(
        'itad-api/prices',
        method: HttpMethod.post,
        queryParameters: {
          'country': country,
          'shops': stores.join(','),
          'deals': 'false',
          'vouchers': 'true',
          'capacity': '0',
        },
        body: ids,
      );

      return Parsers.prices(prices.data);
    } catch (error, stackTrace) {
      Logger().e(
        'Failed to fetch prices',
        error: error,
      );

      Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

      return {};
    }
  }

  Future<List<Store>> stores() async {
    final String country = await settingsReporsitory.getCountry();

    final Uri url = Uri.https(BASE_URL, '/service/shops/v1', {
      'key': API_KEY,
      'country': country,
    });

    final stores = await dio.get(
      url.toString(),
      options: cacheOptions
          .copyWith(
            policy: CachePolicy.forceCache,
          )
          .toOptions(),
    );

    return Parsers.stores(stores);
  }

  Future<List<Deal>> fetchDeals({
    final int limit = DEALS_COUNT,
    final int offset = 0,
  }) async {
    final String country = await settingsReporsitory.getCountry();
    final List<int> stores = await settingsReporsitory.getSelectedStores();
    final ITADFilters filters = settingsReporsitory.getITADFilters();

    final FunctionResponse response =
        await Supabase.instance.client.functions.invoke(
      'itad-api/deals',
      method: HttpMethod.get,
      queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'country': country,
        'shops': stores.join(','),
        'nondeals': filters.nondeals.toString(),
        'mature': filters.mature.toString(),
        'sort': SORT_BY_FILTER_STRINGS[SortDealsBy.values
            .byName(filters.sortBy ?? SortDealsBy.trending.name)],
        'filter': filters.filtersString,
        'include_prices': 'true',
        'deals': 'false',
        'vouchers': 'true',
      },
    );

    return Parsers.deals(response.data);
  }

  Future<List<Deal>> getDealsBySteamIds(
    List<Deal> deals,
  ) async {
    final List<Store> allStores = await stores();
    final int steamStoreId = allStores
        .firstWhere(
          (e) => e.title == 'Steam',
        )
        .id;
    final Uri url = Uri.https(BASE_URL, '/lookup/id/shop/$steamStoreId/v1', {
      'key': API_KEY,
    });
    final List<String?> steamAppIds = deals
        .map(
          (e) => e.steamId,
        )
        .whereType<String>()
        .toList();

    final response = await dio.post(
      url.toString(),
      data: json.encode(steamAppIds),
    );

    final Map<String, dynamic> idsMap = json.decode(response.toString());

    return deals
        .map(
          (e) => e.copyWith(id: idsMap[e.steamId] ?? 'none'),
        )
        .where((e) => e.id != 'none')
        .toList();
  }

  Future<List<Deal>> getByAppIDs(List<Deal> deals) async {
    final List<Deal> foundDeals = await getDealsBySteamIds(deals);

    return fetchDealData(
      deals: foundDeals,
    );
  }

  Future<List<Deal>> fetchSteamWishlist(String steamId) async {
    final Map<String, dynamic> results = {};

    for (int i = 0; i < MAX_STEAM_WISHLIST_PAGES; i++) {
      final Uri steamAPI = Uri.https(
        'store.steampowered.com',
        '/wishlist/profiles/$steamId/wishlistdata/',
        {'p': '$i'},
      );
      final steamResponse = await dio.get(steamAPI.toString());
      final response = json.decode(steamResponse.toString());

      if (response is List) {
        break;
      }

      results.addAll(response);
    }

    return results.entries
        .map(
          (e) => Deal(
            id: 'none',
            title: e.value['name'],
            steamId: 'app/${e.key}',
            added: (e.value['added'] ?? 0) * 1000,
            source: DealSource.steam,
          ),
        )
        .toList();
  }

  Future<List<Deal>> fetchSteamLibrary(String steamId) async {
    final FunctionResponse steamLibrary =
        await Supabase.instance.client.functions.invoke(
      'steam-api/library',
      method: HttpMethod.get,
      queryParameters: {
        'steamid': steamId,
      },
    );

    return steamLibrary.data
        .map<Deal>(
          (e) => Deal(
            id: 'none',
            title: e['name'],
            steamId: 'app/${e['appid']}',
            source: DealSource.steam,
          ),
        )
        .toList();
  }

  Future<SteamUser> fetchSteamUser(String steamId) async {
    final FunctionResponse steamUser =
        await Supabase.instance.client.functions.invoke(
      'steam-api/user',
      method: HttpMethod.get,
      queryParameters: {
        'steamid': steamId,
      },
    );

    return SteamUser.fromJson(steamUser.data);
  }

  Future<List<Deal>> fetchDealData({
    required List<Deal> deals,
  }) async {
    if (deals.isEmpty) {
      return [];
    }

    final List<String> ids = deals.map((e) => e.id).toList();
    final Map<String, List<Price>?> listOfPrices = await prices(ids: ids);

    return deals.map(
      (deal) {
        return deal.copyWith(
          prices: listOfPrices[deal.id] ?? [],
        );
      },
    ).toList();
  }

  Future<List<Deal>> fetchWaitlist() async {
    final List<Deal> deals = settingsReporsitory.getWaitlistDeals();
    final List<String> ids = deals.map((e) => e.id).toList();

    if (ids.isEmpty) {
      return [];
    }

    final Map<String, List<Price>?> mapOfPrices = await prices(ids: ids);

    return deals.map(
      (deal) {
        return deal.copyWith(
          prices: mapOfPrices[deal.id] ?? [],
        );
      },
    ).toList();
  }

  Future<List<Deal>> getSearchResults({
    required final String query,
    final int limit = 20,
    final int offset = 0,
  }) async {
    final Uri url = Uri.https(BASE_URL, '/games/search/v1', {
      'key': API_KEY,
      'title': query.toString(),
      'results': 30.toString(),
    });

    final response = await dio.get(url.toString());
    final List<Deal> deals = Parsers.searchResults(response);

    return fetchDealData(deals: deals);
  }

  Future<Map<String, dynamic>?> lookupSteamIds({
    required List<String> ids,
  }) async {
    try {
      final Uri url = Uri.https(BASE_URL, '/unstable/id-lookup/steam/v1', {
        'key': API_KEY,
      });

      final response = await dio.post(url.toString(), data: json.encode(ids));

      return json.decode(response.toString());
    } catch (error, stackTrace) {
      Logger().e(
        'Failed to fetch steam ID mappings',
        error: error,
      );

      Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  Future<List<History>?> history({
    required String id,
  }) async {
    try {
      final List<int> stores = await settingsReporsitory.getSelectedStores();
      final String country = await settingsReporsitory.getCountry();

      final Uri url = Uri.https(BASE_URL, '/games/history/v2', {
        'key': API_KEY,
        'id': id,
        'shops': stores.join(','),
        'country': country,
      });

      return Parsers.history(await dio.get(url.toString()));
    } catch (error, stackTrace) {
      Logger().e(
        'Failed to fetch history',
        error: error,
      );

      Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }
}
