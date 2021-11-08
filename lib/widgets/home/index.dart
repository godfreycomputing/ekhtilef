import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../menu/appbar.dart';
import '../../models/app_model.dart';
import '../../models/notification_model.dart';
import '../../modules/dynamic_layout/config/logo_config.dart';
import '../../modules/dynamic_layout/dynamic_layout.dart';
import '../../modules/dynamic_layout/logo/logo.dart';
import '../../screens/blog/models/list_blog_model.dart';
import '../../screens/cart/cart_screen.dart';
import '../../services/index.dart';
import 'preview_overlay.dart';

class HomeLayout extends StatefulWidget {
  final configs;
  final bool isPinAppBar;
  final bool isShowAppbar;
  final bool showNewAppBar;

  const HomeLayout({
    this.configs,
    this.isPinAppBar = false,
    this.isShowAppbar = true,
    this.showNewAppBar = false,
    Key? key,
  }) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late List widgetData;

  bool isPreviewingAppBar = false;

  @override
  void initState() {
    /// init config data
    widgetData =
        List<Map<String, dynamic>>.from(widget.configs['HorizonLayout']);
    if (widgetData.isNotEmpty && widget.isShowAppbar && !widget.showNewAppBar) {
      widgetData.removeAt(0);
    }

    /// init single vertical layout
    if (widget.configs['VerticalLayout'] != null &&
        widget.configs['VerticalLayout'].isNotEmpty) {
      Map verticalData =
          Map<String, dynamic>.from(widget.configs['VerticalLayout']);
      verticalData['type'] = 'vertical';
      widgetData.add(verticalData);
    }

    /// init multi vertical layout
    if (widget.configs['VerticalLayouts'] != null) {
      List verticalLayouts = widget.configs['VerticalLayouts'];
      for (var i = 0; i < verticalLayouts.length; i++) {
        Map verticalData = verticalLayouts[i];
        verticalData['type'] = 'vertical';
        widgetData.add(verticalData);
      }
    }

    super.initState();
  }

  @override
  void didUpdateWidget(HomeLayout oldWidget) {
    if (oldWidget.configs != widget.configs) {
      /// init config data
      List data =
          List<Map<String, dynamic>>.from(widget.configs['HorizonLayout']);
      if (data.isNotEmpty && widget.isShowAppbar && !widget.showNewAppBar) {
        data.removeAt(0);
      }

      /// init vertical layout
      if (widget.configs['VerticalLayout'] != null) {
        Map verticalData =
            Map<String, dynamic>.from(widget.configs['VerticalLayout']);
        verticalData['type'] = 'vertical';
        data.add(verticalData);
      }
      setState(() {
        widgetData = data;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  SliverAppBar renderAppBar() {
    List<dynamic> horizonLayout = widget.configs['HorizonLayout'] ?? [];
    Map logoConfig = horizonLayout.firstWhere(
        (element) => element['layout'] == 'logo',
        orElse: () => Map<String, dynamic>.from({}));
    var config = LogoConfig.fromJson(logoConfig);

    /// customize theme
    // config
    //   ..opacity = 0.9
    //   ..iconBackground = HexColor('DDDDDD')
    //   ..iconColor = HexColor('330000')
    //   ..iconOpacity = 0.8
    //   ..iconRadius = 40
    //   ..iconSize = 24
    //   ..cartIcon = MenuIcon(name: 'cart')
    //   ..showSearch = false
    //   ..showLogo = true
    //   ..showCart = true
    //   ..showMenu = true;

    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      pinned: widget.isPinAppBar,
      snap: true,
      floating: true,
      titleSpacing: 0,
      elevation: 0,
      forceElevated: true,
      backgroundColor: config.color ??
          Theme.of(context).backgroundColor.withOpacity(config.opacity),
      title: PreviewOverlay(
          index: 0,
          config: logoConfig as Map<String, dynamic>?,
          builder: (value) {
            final appModel = Provider.of<AppModel>(context, listen: true);
            return Logo(
              key: value['key'] != null ? Key(value['key']) : UniqueKey(),
              config: config,
              logo: appModel.themeConfig.logo,
              notificationCount:
                  Provider.of<NotificationModel>(context).unreadCount,
              onSearch: () =>
                  Navigator.of(context).pushNamed(RouteList.homeSearch),
              onTapNotifications: () {
                Navigator.of(context).pushNamed(RouteList.notify);
              },
              onCheckout: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Scaffold(
                      backgroundColor: Theme.of(context).backgroundColor,
                      body: const CartScreen(isModal: true),
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
              onTapDrawerMenu: () => NavigateTools.onTapOpenDrawerMenu(context),
            );
          }),
    );
  }

  SliverAppBar renderNewAppBar() {
    Map<String, dynamic> appBarConfig = widget.configs['AppBar'] ?? {};
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      pinned: widget.isPinAppBar,
      snap: true,
      floating: true,
      titleSpacing: 0,
      elevation: 0,
      forceElevated: true,
      backgroundColor: Theme.of(context).backgroundColor,
      title: PreviewOverlay(
          index: 0,
          config: appBarConfig,
          builder: (value) {
            return FluxAppBar();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.configs == null) return Container();

    ErrorWidget.builder = (error) {
      if (kReleaseMode) {
        return Container();
      }
      return Container(
        constraints: const BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        /// Hide error, if you're developer, enable it to fix error it has
        child: Center(
          child: Text('Error in ${error.exceptionAsString()}'),
        ),
      );
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomScrollView(
          cacheExtent: 2000.0,
          physics: const BouncingScrollPhysics(),
          slivers: [
            if (widget.showNewAppBar) renderNewAppBar(),
            if (widget.isShowAppbar && !widget.showNewAppBar) renderAppBar(),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await Provider.of<ListBlogModel>(context, listen: false)
                    .getBlogs();
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var config = widgetData[index];

                  /// if show app bar, the preview should plus +1
                  var previewIndex = widget.isShowAppbar ? index + 1 : index;

                  if (config['type'] != null && config['type'] == 'vertical') {
                    return PreviewOverlay(
                        index: previewIndex,
                        config: config,
                        builder: (value) {
                          return Services().widget.renderVerticalLayout(value);
                        });
                  }

                  return PreviewOverlay(
                    index: previewIndex,
                    config: config,
                    builder: (value) {
                      return DynamicLayout(value);
                    },
                  );
                },
                childCount: widgetData.length,
              ),
            ),
          ],
        ),
        const _FakeStatusBar(),
      ],
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: const SafeArea(
          bottom: false,
          child: SizedBox(),
        ),
      ),
    );
  }
}
