import 'package:flutter/material.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    switch (settings.name) {
      // case LoginScreen.routeName:
      //   return FadeRoute(page: LoginScreen());
      // case RegisterScreen.routeName:
      //   return AnimatedRoute(page: RegisterScreen());
      // case BottomTabBar.routeName:
      //   return FadeRoute(page: BottomTabBar());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Errorx'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}