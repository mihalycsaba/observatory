import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:observatory/deals/deals_provider.dart';
import 'package:observatory/deals/deals_state.dart';
import 'package:observatory/settings/settings_repository.dart';
import 'package:observatory/shared/models/deal.dart';
import 'package:observatory/shared/models/price.dart';
import 'package:observatory/shared/models/shop.dart';

final List<Deal> deals = [
  const Deal(
    id: '018d937f-636c-72e7-ac79-de13a54877c8',
    slug: 'slay-the-princess',
    type: 'game',
    title: 'Slay the Princess',
    steamId: null,
    prices: [
      Price(
        price: PriceDetails(
          amount: 14.39,
          amountInt: 1439,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 17.99,
          amountInt: 1799,
          currency: 'USD',
        ),
        cut: 20.0,
        shop: Shop(
          id: 61,
          name: 'Steam',
        ),
        drm: [],
        url: 'https://itad.link/018d9386-cb20-727a-9d0d-2ea25e9fde79/',
        voucher: null,
        timestamp: '2024-03-25T18:18:30+01:00',
      ),
    ],
    info: null,
    overview: null,
    isLoading: false,
    added: 0,
    source: DealSource.itad,
  ),
  const Deal(
    id: '018d937f-590c-728b-ac35-38bcff85f086',
    slug: 'elden-ring',
    type: 'game',
    title: 'Elden Ring',
    steamId: null,
    prices: [
      Price(
        price: PriceDetails(
          amount: 52.23,
          amountInt: 5223,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 59.99,
          amountInt: 5999,
          currency: 'USD',
        ),
        cut: 13.0,
        shop: Shop(
          id: 20,
          name: 'GameBillet',
        ),
        drm: [DRM(id: 61, name: 'Steam')],
        url: ' https://itad.link/018d9386-5634-71ca-ac17-8fff3f127b84/',
        voucher: null,
        timestamp: '2024-02-28T15:06:18+01:00',
      ),
    ],
    info: null,
    overview: null,
    isLoading: false,
    added: 0,
    source: DealSource.itad,
  ),
  const Deal(
    id: '018d937e-fda5-726b-837e-0baaa34c7519',
    slug: 'lisa-complete-edition',
    type: 'dlc',
    title: 'LISA: Complete Edition',
    steamId: null,
    prices: [
      Price(
        price: PriceDetails(
          amount: 26.24,
          amountInt: 2624,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 34.99,
          amountInt: 3499,
          currency: 'USD',
        ),
        cut: 25.0,
        shop: Shop(
          id: 61,
          name: 'Steam',
        ),
        drm: [DRM(id: 61, name: 'Steam')],
        url: 'https://itad.link/018d9386-8d27-715f-89f5-3d82ed507bbd/',
        voucher: null,
        timestamp: '2024-03-22T17:15:14+01:00',
      )
    ],
    info: null,
    overview: null,
    isLoading: false,
    added: 0,
    source: DealSource.itad,
  ),
  const Deal(
    id: '018d937f-138d-724f-82bb-f180b2ea819a',
    slug: 'katana-zero',
    type: 'game',
    title: 'Katana ZERO',
    steamId: null,
    prices: [
      Price(
        price: PriceDetails(
          amount: 8.99,
          amountInt: 899,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 14.99,
          amountInt: 1499,
          currency: 'USD',
        ),
        cut: 40.0,
        shop: Shop(
          id: 35,
          name: 'GOG',
        ),
        drm: [DRM(id: 1000, name: 'Drm Free')],
        url: ' https://itad.link/018d9386-8560-7202-bdc7-7f4b18d43fa8/',
        voucher: null,
        timestamp: ' 2024-03-19T14:51:44+01:00',
      ),
    ],
    info: null,
    overview: null,
    isLoading: false,
    added: 0,
    source: DealSource.itad,
  ),
  const Deal(
    id: '018d937f-4382-707a-85b5-cdf1984ea8a8',
    slug: 'persona-4-golden',
    type: 'game',
    title: 'Persona 4 Golden',
    steamId: null,
    prices: [
      Price(
        price: PriceDetails(
          amount: 16.39,
          amountInt: 1639,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 19.99,
          amountInt: 1999,
          currency: 'USD',
        ),
        cut: 18.0,
        shop: Shop(
          id: 20,
          name: 'GameBillet',
        ),
        drm: [DRM(id: 61, name: 'Steam')],
        url: 'https://itad.link/018d9386-ab6b-7286-b947-4631a252d9a7/',
        voucher: null,
        timestamp: '2024-02-20T01:21:20+01:00',
      ),
    ],
    info: null,
    overview: null,
    isLoading: false,
    added: 0,
    source: DealSource.itad,
  ),
];

class AsyncDealsNotifierMock
    extends AutoDisposeFamilyAsyncNotifier<DealsState, DealCategory>
    with Mock
    implements AsyncDealsNotifier {
  Future<DealsState> _initDeals() async {
    return DealsState(
      deals: deals,
      hasReachedMax: false,
      pageNumber: 1,
    );
  }

  @override
  Future<DealsState> build(DealCategory arg) async {
    return _initDeals();
  }

  @override
  Future<void> fetchMore() async {
    state = state;
  }

  @override
  Future<List<Deal>> fetchDeals({int offset = 0}) async {
    return deals;
  }

  @override
  Future<void> reset() async {
    state = state;
  }
}