import 'package:dio/dio.dart';
import '../common/appConfig.dart';
import '../constants.dart';

class LanguageInterceptor extends Interceptor {
  @override
  Future onRequest(options, handler) async {
    // Get the language.
    String lang  = await appConfig.currentLanguage();
    if (lang.isNotEmpty) {
      options.headers[HEADER_LANGUAGE] = lang;
      print(options.headers);
    }

    return super.onRequest(options, handler);
  }
}

class AuthInterceptor extends Interceptor {
  @override
  Future onRequest(options, handler) async {
  }
}
