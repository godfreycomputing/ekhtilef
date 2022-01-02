import 'package:get_it/get_it.dart';
import 'core/net/http_client.dart';

final GetIt inject = GetIt.I;

Future<void> setupInjection() async {
  //Components
  inject.registerSingleton(HttpClient());

}