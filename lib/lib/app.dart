import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/common/app_colors.dart';
import 'core/constants.dart';
import 'core/localization/translations.dart';
import 'core/route/route_generator.dart';
import 'feature/image_editer_pro/screen/image_editor_pro.dart';

final navigationKey = GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  //final AppConfigProvider appLanguage;

  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Init Language.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
              debugShowCheckedModeBanner: false,
              title: TITLE_APP_NAME,
              themeMode: ThemeMode.light,
              // set this Widget as root
              //initialRoute: '/',
              //navigatorKey: navigationKey,
              //onGenerateRoute: RouteGenerator.generateRoute,
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  color: AppColors.primaryColor,
                ),
                primaryColor: AppColors.primaryColor,
                snackBarTheme: const SnackBarThemeData(
                  actionTextColor: AppColors.white_text,
                  backgroundColor: AppColors.accentColor,
                  behavior: SnackBarBehavior.fixed,
                  elevation: 5.0,
                ),
                scaffoldBackgroundColor: AppColors.backgroundColor, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accentColor),
              ),
              supportedLocales: const [
                // first
                 Locale(LANG_EN),
                // last
                 Locale(LANG_AR),
              ],
              locale:const Locale(LANG_EN),
              // These delegates make sure that the localization data for the proper language is loaded
              localizationsDelegates: const[
                Translations.delegate,
                // Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,
                // Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
                home: TShirtEditor());
            
  }

}
