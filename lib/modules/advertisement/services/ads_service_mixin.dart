import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/app_model.dart';

mixin AdsServiceMixin {
  /// Facebook and Google Ads init
  void initAdvertise(context) {
    /// Facebook Ads init
    final advertisement =
        Provider.of<AppModel>(context, listen: false).advertisement;
    if (advertisement.enable && !kIsWeb) {
      printLog(
          '[AppState] Init Google Mobile Ads and Facebook Audience Network');
      unawaited(FacebookAudienceNetwork.init(
          testingId: advertisement.facebookTestingId));

      unawaited(
          MobileAds.instance.initialize().then((InitializationStatus status) {
        printLog('Initialization done: ${status.adapterStatuses}');

        MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
          tagForChildDirectedTreatment:
              TagForChildDirectedTreatment.unspecified,
          testDeviceIds: advertisement.googleTestingId,
        ));
      }));
    }
  }
}
