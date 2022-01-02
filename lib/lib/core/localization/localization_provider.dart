import 'package:flutter/material.dart';
import '../datasource/shared_preference.dart';
import '../constants.dart';
import 'restart_widget.dart';

class AppConfigProvider extends ChangeNotifier {
  Locale _appLocale = Locale(LANG_EN);

  /// Get current Locale supported
  Locale get appLocal => _appLocale;
  Future<dynamic> fetchLocale() async {
    var prefs = await SpUtil.getInstance();
    /// check if the application is first start or not
    if(prefs.getBool(KEY_FIRST_START) == null){
      /// set first start is true
      await prefs.putBool(KEY_FIRST_START, true);
    }
    if (prefs.getString(KEY_LANGUAGE) == null) {
      _appLocale = const Locale(LANG_EN);
      await prefs.putString(KEY_LANGUAGE, LANG_EN);
      return Null;
    }
    _appLocale = Locale(await prefs.getString(KEY_LANGUAGE));
    return Null;
  }

  Future<void> changeLanguage(Locale type,BuildContext context) async {
    var prefs = await SpUtil.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale(LANG_AR)) {
      _appLocale = Locale(LANG_AR);
      await prefs.putString(KEY_LANGUAGE, LANG_AR);
    }
    else {
      _appLocale = Locale(LANG_EN);
      await prefs.putString(KEY_LANGUAGE, LANG_EN);
    }
    notifyListeners();
    RestartWidget.restartApp(context);
  }
}