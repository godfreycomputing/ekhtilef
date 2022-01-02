import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/common/appConfig.dart';
import 'core/localization/localization_provider.dart';
import 'service_locator.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  
  runApp(
    const App(),
  );
}