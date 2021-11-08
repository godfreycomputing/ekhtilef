import '../../../services/service_config.dart';
import '../index.dart';
import 'woo_commerce.dart';

mixin WooMixin on ConfigMixin {
  @override
  void configWoo(appConfig) {
    final wooService = WooCommerceService(
      domain: appConfig['url'],
      blogDomain: appConfig['blog'],
      consumerSecret: appConfig['consumerSecret'],
      consumerKey: appConfig['consumerKey'],
    );
    api = wooService;
    widget = WooWidget();
  }
}
