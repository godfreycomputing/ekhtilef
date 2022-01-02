import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_init.dart';
import 'common/config.dart';
import 'common/constants.dart';
import 'common/theme/index.dart';
import 'common/tools.dart';
import 'generated/l10n.dart';
import 'generated/languages/index.dart';
import 'models/index.dart';
import 'routes/route.dart';
import 'screens/blog/models/list_blog_model.dart';
import 'services/index.dart';
import 'widgets/overlay/custom_overlay_state.dart';

class App extends StatefulWidget {
  final String languageCode;

  const App({
    required this.languageCode,
  });

  static final GlobalKey<NavigatorState> fluxStoreNavigatorKey = GlobalKey();

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App>
    with WidgetsBindingObserver
    implements NotificationDelegate, UserModelDelegate {
  AppModel? _app;
  final _product = ProductModel();
  final _wishlist = ProductWishListModel();
  final _shippingMethod = ShippingMethodModel();
  final _paymentMethod = PaymentMethodModel();
  final _recent = RecentModel();
  final _user = UserModel();
  final _filterModel = FilterAttributeModel();
  final _filterTagModel = FilterTagModel();
  final _categoryModel = CategoryModel();
  final _tagModel = TagModel();
  final _taxModel = TaxModel();
  final _pointModel = PointModel();
  final _notificationModel = NotificationModel();

  /// ---------- Vendor -------------
  StoreModel? _storeModel;
  VendorShippingMethodModel? _vendorShippingMethodModel;

  /// -------- Listing ------------///
  final _listingLocationModel = ListingLocationModel();

  CartInject cartModel = CartInject();
  bool isFirstSeen = false;
  bool isLoggedIn = false;

  // late var firebaseAnalyticsAbs;

  void appInitialModules() {
    var startTime = DateTime.now();

    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        _user.delegate = this;
        final notificationService = injector<NotificationService>();
        notificationService.init(notificationDelegate: this);
        notificationService.requestPermission();
        printLog(
            '[AppState] Register Firebase or OneSignal Modules', startTime);
      },
    );
  }

  /// Build the App Theme
  ThemeData getTheme(context) {
    var appModel = Provider.of<AppModel>(context);
    var isDarkTheme = appModel.darkTheme;

    if (appModel.appConfig == null) {
      /// This case is loaded first time without config file
      return buildLightTheme(appModel.langCode);
    }

    var fontFamily = appModel.appConfig!.settings.fontFamily;
    var fontHeader = appModel.appConfig!.settings.fontHeader;

    ThemeData themeData;
    if (isDarkTheme) {
      themeData = buildDarkTheme(appModel.langCode, fontFamily, fontHeader);
    } else {
      themeData = buildLightTheme(appModel.langCode, fontFamily, fontHeader);
    }

    var colorScheme = themeData.colorScheme.copyWith(
      primary: HexColor(
        appModel.mainColor,
      ),
    );

    return themeData.copyWith(
      primaryColor: HexColor(
        appModel.mainColor,
      ),
      colorScheme: colorScheme,
    );
  }

  void updateDeviceToken(User? user) {
    if (GmsTools().isGmsAvailable) {
      Services().firebase.getMessagingToken().then((token) {
        try {
          Services().api.updateUserInfo({'deviceToken': token}, user!.cookie);
        } catch (e) {
          printLog(e);
        }
      });
    }
  }

  @override
  void initState() {
    printLog('[AppState] initState');
    _app = AppModel(widget.languageCode);
    WidgetsBinding.instance?.addObserver(this);

    appInitialModules();

    super.initState();
  }

  @override
  Future<void> onLoaded(User? user) async {
    updateDeviceToken(user);

    /// init Cart Modal
    cartModel.model.changeCurrencyRates(_app?.currencyRate);

    /// save logged in user
    cartModel.model.setUser(user);
    if (user?.cookie != null &&
        (kAdvanceConfig['EnableSyncCartFromWebsite'] ?? true)) {
      await Services()
          .widget
          .syncCartFromWebsite(user?.cookie, cartModel.model, context);
    }

    if (user?.cookie != null && (kAdvanceConfig['EnablePointReward'] ?? true)) {
      await _pointModel.getMyPoint(user?.cookie);
    }

    /// Preload address.
    await cartModel.model.getAddress();
  }

  @override
  Future<void> onLoggedIn(User user) async => onLoaded(user);

  @override
  Future<void> onLogout(User? user) async {
    cartModel.model.clearCart();
    await _wishlist.clearWishList();
    if (Services().firebase.isEnabled) {
      try {
        await Services().api.updateUserInfo({'deviceToken': ''}, user!.cookie);
      } catch (e) {
        printLog(e);
      }
    }
  }

  @override
  void onTapMessage(FStoreNotificationItem notification) {}

  @override
  void onMessage(FStoreNotificationItem notification) {
    printLog(notification.toJson());
    _notificationModel.saveMessage(notification);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _notificationModel.checkGranted();
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog('[AppState] Build app.dart'); 
    return ChangeNotifierProvider<AppModel>.value(
      value: _app!,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          var languageCode = value.langCode!.isEmptyOrNull
              ? kAdvanceConfig['DefaultLanguage']
              : value.langCode;

          if (value.vendorType == VendorType.multi &&
              _storeModel == null &&
              _vendorShippingMethodModel == null) {
            _storeModel = StoreModel();
            _vendorShippingMethodModel = VendorShippingMethodModel();
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MultiProvider(
              providers: [
                Provider<ProductModel>.value(value: _product),
                Provider<ProductWishListModel>.value(value: _wishlist),
                Provider<ShippingMethodModel>.value(value: _shippingMethod),
                Provider<PaymentMethodModel>.value(value: _paymentMethod),
                Provider<RecentModel>.value(value: _recent),
                Provider<UserModel>.value(value: _user),
                ChangeNotifierProvider<ListBlogModel>(
                    create: (_) => ListBlogModel()),
                ChangeNotifierProvider<FilterAttributeModel>(
                    create: (_) => _filterModel),
                ChangeNotifierProvider<FilterTagModel>(
                    create: (_) => _filterTagModel),
                ChangeNotifierProvider<CategoryModel>(
                    create: (_) => _categoryModel),
                ChangeNotifierProvider(create: (_) => _tagModel),
                ChangeNotifierProvider(
                    create: (_) => cartModel.model, lazy: true),
                Provider<TaxModel>.value(value: _taxModel),
                ChangeNotifierProvider.value(value: _notificationModel),
                if (value.vendorType == VendorType.multi) ...[
                  ChangeNotifierProvider<StoreModel>(
                      create: (_) => _storeModel!),
                  ChangeNotifierProvider<VendorShippingMethodModel>(
                      create: (_) => _vendorShippingMethodModel!),
                ],
                Provider<PointModel>.value(value: _pointModel),
                if (Config().isListingType) ...[
                  ChangeNotifierProvider<ListingLocationModel>(
                      create: (_) => _listingLocationModel)
                ],
                ChangeNotifierProvider<BlogModel>(create: (_) => BlogModel()),
                ChangeNotifierProvider<TextStyleModel>(
                    create: (_) => TextStyleModel()),
                ChangeNotifierProvider(create: (_) => BlogWishListModel()),
                ChangeNotifierProvider<BrandModel>(create: (_) => BrandModel()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: Locale(
                    languageCode ?? kAdvanceConfig['DefaultLanguage'], ''),
                navigatorKey: App.fluxStoreNavigatorKey,
                navigatorObservers: [
                  MyRouteObserver(
                      action: (screenName) =>
                          OverlayControlDelegate().emitRoute?.call(screenName)),
                  ...Services().firebase.getMNavigatorObservers(),
                ],
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  LocalWidgetLocalizations.delegate,
                  SubMaterialLocalizations.delegate,
                  SubCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                home: const Scaffold(
                  body: AppInit(),
                ),
                routes: Routes.getAll(),
                onGenerateRoute: Routes.getRouteGenerate,
                theme: getTheme(context),
                themeMode: value.themeMode,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void onMessageOpenedApp(FStoreNotificationItem notification) {}
}
