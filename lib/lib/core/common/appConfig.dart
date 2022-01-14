import 'dart:io';
import 'package:package_info/package_info.dart';
import '../datasource/shared_preference.dart';
import '../constants.dart';

// This class it contain tow functions
// for get device info
// and for get and set language and check if has token or not
class AppConfig {
  static  String lang ="" ;
  late int os;
  late String currentVersion;
  late String buildNumber;
  late String appName;

  initVersion() async {
    /// get OS
    if (Platform.isIOS) {
      os = 2;
    }
    if (Platform.isAndroid) {
      os = 1;
    }

    /// get version
    final packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    appName = packageInfo.appName;
  }

  // get current language from shared pref
  Future<String> currentLanguage() async {
    final prefs = await SpUtil.getInstance();
      lang = await prefs.getString(KEY_LANGUAGE);
    if(lang != null) return lang;
    else return LANG_EN;
  }
}

AppConfig appConfig = AppConfig();
