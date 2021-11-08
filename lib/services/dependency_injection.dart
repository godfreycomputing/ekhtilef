import 'package:get_it/get_it.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';
import 'audio/audio_service.dart';
import 'location_service.dart';
import 'notification/notification_service.dart';
import 'services.dart';

GetIt injector = GetIt.instance;

class DependencyInjection {
  static Future<void> inject() async {
    final locationService = LocationService();
    injector.registerSingleton<LocationService>(locationService);

    final sharedPreferences = await SharedPreferences.getInstance();
    injector.registerSingleton<SharedPreferences>(sharedPreferences);

    var notificationService = Services.getNotificationService();
    injector.registerSingleton<NotificationService>(notificationService);

    final localStorage = LocalStorage(LocalStorageKey.app);
    await localStorage.ready;
    injector.registerSingleton<LocalStorage>(localStorage);

    /// audio service
    var audioService = Services().getAudioService();
    injector.registerLazySingleton<AudioService>(() => audioService);
  }
}
