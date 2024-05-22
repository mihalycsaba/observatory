import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:observatory/deals/deals_provider.dart';
import 'package:observatory/main.dart';
import 'package:observatory/search/search_provider.dart';
import 'package:observatory/waitlist/waitlist_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:observatory/firebase_options.dart';
import 'package:observatory/secret_loader.dart';
import 'package:observatory/settings/settings_repository.dart';
import 'package:observatory/shared/api/api.dart';

import './mocks/deals_mocks.dart';
import './mocks/waitlist_mocks.dart';
import './mocks/search_mocks.dart';

void main() async {
  WidgetsApp.debugAllowBannerOverride = false;

  enableFlutterDriverExtension(enableTextEntryEmulation: false);

  await SettingsRepository.init();

  GetIt.I.registerSingleton<SettingsRepository>(SettingsRepository());
  GetIt.I.registerSingleton<API>(await API.create());
  GetIt.I.registerSingleton<Secret>(await SecretLoader.load());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate();

  runApp(
    ProviderScope(
      overrides: [
        asyncWaitListProvider.overrideWith(AsyncWaitListNotifierMock.new),
        asyncDealsProvider.overrideWith(AsyncDealsNotifierMock.new),
        searchProvider.overrideWithProvider(
          (type) {
            if (type == SearchType.search) {
              return searchResultsProviderMock;
            }

            return filterResultsProvider;
          },
        ),
      ],
      child: const Observatory(),
    ),
  );
}
