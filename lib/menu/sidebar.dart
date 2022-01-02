import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:inspireui/icons/icon_picker.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../common/config.dart';
import '../common/config/models/index.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../generated/l10n.dart';
import '../models/index.dart'
    show AppModel, BackDropArguments, Category, CategoryModel, UserModel;
import '../modules/dynamic_layout/config/app_config.dart';
import '../routes/flux_navigate.dart';
import '../screens/posts/post_screen.dart';
import '../services/audio/audio_service.dart';
import '../services/index.dart';
import '../services/service_config.dart';
import '../widgets/common/webview.dart';
import 'maintab_delegate.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu();

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<SideBarMenu> {
  bool get isEcommercePlatform =>
      !Config().isListingType || !Config().isWordPress;

  void pushNavigation(String name) {
    eventBus.fire(const EventCloseNativeDrawer());
    MainTabControlDelegate.getInstance().changeTab(name.replaceFirst('/', ''));
  }

  final RateMyApp _rateMyApp = RateMyApp(
      // rate app on store
      minDays: 7,
      minLaunches: 10,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: kStoreIdentifier['android'],
      appStoreIdentifier: kStoreIdentifier['ios']);

  void showRateMyApp() {
    _rateMyApp.showRateDialog(
      context,
      title: S.of(context).rateTheApp,
      // The dialog title.
      message: S.of(context).rateThisAppDescription,
      // The dialog message.
      rateButton: S.of(context).rate.toUpperCase(),
      // The dialog 'rate' button text.
      noButton: S.of(context).noThanks.toUpperCase(),
      // The dialog 'no' button text.
      laterButton: S.of(context).maybeLater.toUpperCase(),
      // The dialog 'later' button text.
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            break;
          case RateMyAppDialogButton.later:
            break;
          case RateMyAppDialogButton.no:
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      // Set to false if you want to show the native Apple app rating dialog on iOS.
      dialogStyle: const DialogStyle(),
      // Custom dialog styles.
      // Called when the user dismissed the dialog (either by taping outside or by pressing the 'back' button).
      // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isMobile) {
      _rateMyApp.init().then((_) {
        // state of rating the app
        if (_rateMyApp.shouldOpenDialog) {
          showRateMyApp();
        }
      });
    }
  }

  void contactUs() {}

  @override
  Widget build(BuildContext context) {
    printLog('[AppState] Load Menu');

    var drawer =
        Provider.of<AppModel>(context, listen: false).appConfig?.drawer ??
            kDefaultDrawer;

    return Padding(
      padding: EdgeInsets.only(
          bottom: injector<AudioService>().isStickyAudioWidgetActive ? 46 : 0),
      child: Column(
          key: drawer.key != null ? Key(drawer.key as String) : UniqueKey(),
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (drawer.logo != null)
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) =>
                              Container(
                                  color: Colors.grey.withOpacity(.3),
                                  height: constraints.maxWidth,
                                  width: constraints.maxWidth,
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset('assets/images/profile.png',
                                          width: 222, height: 222, scale: 2.5),
                                      //  FluxImage(
                                      //   imageUrl: 'assets/images/profile.png',
                                      //   width: 500,
                                      //   height: 500,
                                      // ),
                                      Text(S.of(context).welcomeBack,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  )),
                    ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 30, right: 20),
                      child: Column(children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              FluxNavigate.pushNamed(
                                RouteList.orders,
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  FontAwesomeIcons.truck,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(S.of(context).myOrders,
                                    style: const TextStyle(fontSize: 18))
                              ],
                            )),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.email,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(S.of(context).contactUs,
                                style: const TextStyle(fontSize: 18))
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: showRateMyApp,
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.favorite,
                                color: Colors.pink,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(S.of(context).showSomeLove,
                                  style: const TextStyle(fontSize: 18))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostScreen(
                                    pageId: 81,
                                    pageTitle: S.of(context).agreeWithPrivacy),
                              )),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                FontAwesomeIcons.infoCircle,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(S.of(context).privacyPolicy,
                                  style: const TextStyle(fontSize: 18))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(RouteList.currencies),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  FontAwesomeIcons.syncAlt,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(S.of(context).changeCurrency,
                                    style: const TextStyle(fontSize: 18))
                              ],
                            ))
                      ])),
                  // ...List.generate(
                  //   drawer.items!.length,
                  //   (index) {
                  //     return drawerItem(
                  //         drawer.items![index], drawer.subDrawerItem ?? {});
                  //   },
                  // ),
                  // isDisplayDesktop(context)
                  //     ? const SizedBox(height: 300)
                  //     : const SizedBox(height: 24),
                ],
              ),
            ),
          ]),
    );
  }

  Widget drawerItem(DrawerItemsConfig drawerItemConfig,
      Map<String, GeneralSettingItem> subDrawerItem) {
    // final isTablet = Tools.isTablet(MediaQuery.of(context));

    if (drawerItemConfig.show == false) return const SizedBox();
    var value = drawerItemConfig.type;

    switch (value) {
      case 'home':
        {
          return ListTile(
            leading: Icon(
              isEcommercePlatform ? Icons.home : Icons.shopping_basket,
              size: 20,
            ),
            title: Text(
              isEcommercePlatform ? S.of(context).home : S.of(context).shop,
            ),
            onTap: () {
              pushNavigation(RouteList.home);
            },
          );
        }
      case 'categories':
        {
          return ListTile(
            leading: const Icon(Icons.category, size: 20),
            title: Text(S.of(context).categories),
            onTap: () => pushNavigation(
              Provider.of<AppModel>(context, listen: false).vendorType ==
                      VendorType.single
                  ? RouteList.category
                  : RouteList.vendorCategory,
            ),
          );
        }
      case 'cart':
        {
          if (Config().isListingType) {
            return Container();
          }
          return ListTile(
            leading: const Icon(Icons.shopping_cart, size: 20),
            title: Text(S.of(context).cart),
            onTap: () => pushNavigation(RouteList.cart),
          );
        }
      case 'profile':
        {
          return ListTile(
            leading: const Icon(Icons.person, size: 20),
            title: Text(S.of(context).settings),
            onTap: () => pushNavigation(RouteList.profile),
          );
        }
      case 'web':
        {
          return ListTile(
            leading: const Icon(
              Icons.web,
              size: 20,
            ),
            title: Text(S.of(context).webView),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: 'https://inspireui.com',
                    title: S.of(context).webView,
                  ),
                ),
              );
            },
          );
        }
      case 'blog':
        {
          return ListTile(
            leading: const Icon(CupertinoIcons.news_solid, size: 20),
            title: Text(S.of(context).blog),
            onTap: () => pushNavigation(RouteList.listBlog),
          );
        }
      case 'login':
        {
          return ListenableProvider.value(
            value: Provider.of<UserModel>(context, listen: false),
            child: Consumer<UserModel>(builder: (context, userModel, _) {
              final loggedIn = userModel.loggedIn;
              return ListTile(
                leading: const Icon(Icons.exit_to_app, size: 20),
                title: loggedIn
                    ? Text(S.of(context).logout)
                    : Text(S.of(context).login),
                onTap: () {
                  if (loggedIn) {
                    Provider.of<UserModel>(context, listen: false).logout();
                    if (kLoginSetting['IsRequiredLogin'] ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteList.login,
                        (route) => false,
                      );
                    }
                    // else {
                    //   pushNavigation(RouteList.dashboard);
                    // }
                  } else {
                    pushNavigation(RouteList.login);
                  }
                },
              );
            }),
          );
        }
      case 'category':
        {
          return buildListCategory();
        }
      default:
        {
          var item = subDrawerItem[value];
          var title = item?.title ?? S.of(context).dataEmpty;
          if (value?.contains('web') ?? false) {
            var webUrl = item?.webUrl;
            if (item?.requiredLogin ?? false) {
              var user = Provider.of<UserModel>(context, listen: false).user;
              if (user == null) return const SizedBox();
              var base64Str = EncodeUtils.encodeCookie(user.cookie!);
              webUrl = '$webUrl?cookie=$base64Str';
            }
            return ListTile(
              leading: Icon(item != null
                  ? (iconPicker(item.icon, item.iconFontFamily) ?? Icons.error)
                  : Icons.error),
              title: Text(title),
              onTap: () {
                if (item?.webViewMode ?? false) {
                  FluxNavigate.push(
                    MaterialPageRoute(
                      builder: (context) => WebView(url: webUrl, title: title),
                    ),
                    forceRootNavigator: true,
                  );
                } else {
                  Tools.launchURL(webUrl);
                }
              },
            );
          }
          if (value?.contains('post') ?? false) {
            return ListTile(
              leading: Icon(item != null
                  ? (iconPicker(item.icon, item.iconFontFamily) ?? Icons.error)
                  : Icons.error),
              title: Text(title),
              onTap: () {
                if (item == null) return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostScreen(pageId: item.pageId, pageTitle: title),
                    ));
              },
            );
          }
          if (value?.contains('title') ?? false) {
            var fontSize = item?.fontSize ?? 16.0;
            var titleColor =
                item?.titleColor != null ? HexColor(item!.titleColor) : null;
            var verticalPadding = item?.verticalPadding;
            var enableDivider = item?.enableDivider ?? false;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (enableDivider)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 15.0,
                    color: Theme.of(context).primaryColorLight,
                  ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: verticalPadding?.dx ?? 15.0,
                      bottom: verticalPadding?.dy ?? 15.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: titleColor ??
                              Theme.of(context).colorScheme.secondary,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            );
          }
        }

        return const SizedBox();
    }
  }

  Widget buildListCategory() {
    final categories = Provider.of<CategoryModel>(context).categories;
    var widgets = <Widget>[];

    if (categories != null) {
      var list = categories.where((item) => item.parent == '0').toList();
      for (var i = 0; i < list.length; i++) {
        final currentCategory = list[i];
        var childCategories =
            categories.where((o) => o.parent == currentCategory.id).toList();
        widgets.add(Container(
          color: i.isOdd
              ? Theme.of(context).backgroundColor
              : Theme.of(context).primaryColorLight,

          /// Check to add only parent link category
          child: childCategories.isEmpty
              ? InkWell(
                  onTap: () => navigateToBackDrop(currentCategory),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 12,
                      left: 16,
                      top: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currentCategory.name!.toUpperCase()),
                        const SizedBox(width: 24),
                        currentCategory.totalProduct == null
                            ? const Icon(Icons.chevron_right)
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  S
                                      .of(context)
                                      .nItems(currentCategory.totalProduct!),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              : ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0),
                    child: Text(
                      currentCategory.name!.toUpperCase(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  textColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                  children:
                      getChildren(categories, currentCategory, childCategories)
                          as List<Widget>,
                ),
        ));
      }
    }

    return ExpansionTile(
      initiallyExpanded: true,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      tilePadding: const EdgeInsets.only(left: 16, right: 8),
      title: Text(
        S.of(context).byCategory.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
      ),
      children: widgets,
    );
  }

  List getChildren(
    List<Category> categories,
    Category currentCategory,
    List<Category> childCategories, {
    double paddingOffset = 0.0,
  }) {
    var list = <Widget>[];

    list.add(
      ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 20 + paddingOffset),
          child: Text(S.of(context).seeAll),
        ),
        trailing: Text(
          S.of(context).nItems(currentCategory.totalProduct!),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
        onTap: () => navigateToBackDrop(currentCategory),
      ),
    );
    for (var i in childCategories) {
      var newChildren = categories.where((cat) => cat.parent == i.id).toList();
      if (newChildren.isNotEmpty) {
        list.add(
          ExpansionTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20.0 + paddingOffset),
              child: Text(
                i.name!.toUpperCase(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            children: getChildren(
              categories,
              i,
              newChildren,
              paddingOffset: paddingOffset + 10,
            ) as List<Widget>,
          ),
        );
      } else {
        list.add(
          ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20 + paddingOffset),
              child: Text(i.name!),
            ),
            trailing: Text(
              S.of(context).nItems(i.totalProduct!),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
            onTap: () => navigateToBackDrop(i),
          ),
        );
      }
    }
    return list;
  }

  void navigateToBackDrop(Category category) {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: category.id,
        cateName: category.name,
      ),
    );
  }
}
