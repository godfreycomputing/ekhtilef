import 'dart:async';
import 'dart:io' show HttpClient;

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'common/config.dart';
import 'common/constants.dart';
import 'common/tools.dart';
import 'env.dart';

import 'lib/core/common/appConfig.dart';
import 'lib/core/localization/localization_provider.dart';
import 'lib/service_locator.dart';
import 'services/dependency_injection.dart';
import 'services/locale_service.dart';
import 'services/services.dart';

void main() {
  printLog('[main] ===== START main.dart =======');
  WidgetsFlutterBinding.ensureInitialized();
  Configurations().setConfigurationValues(environment);
  Provider.debugCheckInvalidValueType = null;
  var languageCode =
      kAdvanceConfig['DefaultLanguage'] ?? Configurations.defaultLanguage;

  SharedPreferences.setMockInitialValues({});
  final _appLanguage = AppConfigProvider();
  // Init Language.
  () async {
    await _appLanguage.fetchLocale();
    appConfig.initVersion();
    await setupInjection();
  };
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runZonedGuarded(() async {
    if (!foundation.kIsWeb) {
      /// Enable network traffic logging.
      HttpClient.enableTimelineLogging = !foundation.kReleaseMode;

      /// Lock portrait mode.
      unawaited(SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]));

      Tools.initStatusBarColor();
    }

    if (isMobile) {
      await GmsTools().checkGmsAvailability();

      /// Init Firebase settings due to version 0.5.0+ requires to.
      /// Use await to prevent any usage until the initialization is completed.
      await Services().firebase.init();
      await Configurations().loadRemoteConfig();
    }
    await DependencyInjection.inject();
    Services().setAppConfig(serverConfig);

    if (isMobile) {
      if (kAdvanceConfig['AutoDetectLanguage'] == true) {
        final lang = injector<SharedPreferences>().getString('language');

        if (lang?.isEmpty ?? true) {
          languageCode = await LocaleService().getDeviceLanguage();
        } else {
          languageCode = lang.toString();
        }
      }
    }

    if (serverConfig['type'] == 'vendorAdmin') {
      return runApp(Services().getVendorAdminApp(languageCode: languageCode));
    }

    if (serverConfig['type'] == 'delivery') {
      return runApp(Services().getDeliveryApp(languageCode: languageCode));
    }

    ResponsiveSizingConfig.instance.setCustomBreakpoints(
        const ScreenBreakpoints(desktop: 900, tablet: 600, watch: 100));
    runApp(App(languageCode: languageCode));
  }, (e, stack) {
    printLog(e);
    printLog(stack);
  });
}
