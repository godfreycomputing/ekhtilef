import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/app_setting.dart';
import '../config/tab_bar_config.dart';
import '../helper/helper.dart';
import 'tab_indicator/index.dart';
import 'tabbar_icon.dart';

class TabBarCustom extends StatelessWidget {
  final TabController tabController;
  final Function(int) onTap;
  final List tabData;
  final bool isShowDrawer;
  final AppSetting config;

  final double maxHeight;
  final int totalCart;

  const TabBarCustom({
    Key? key,
    this.maxHeight = 100.0,
    this.isShowDrawer = false,
    required this.config,
    required this.totalCart,
    required this.tabController,
    required this.onTap,
    required this.tabData,
  }) : super(key: key);

  Decoration _buildIndicator(context) {
    var indicator = config.tabBarConfig.tabBarIndicator;

    switch (config.tabBarConfig.indicatorStyle) {
      case IndicatorStyle.dot:
        return DotIndicator(
            radius: indicator.radius ?? 3,
            color: indicator.color ?? Theme.of(context).primaryColor,
            distanceFromCenter: indicator.distanceFromCenter ?? 20.0,
            strokeWidth: indicator.strokeWidth ?? 1.0,
            paintingStyle: indicator.paintingStyle ?? PaintingStyle.fill);
      case IndicatorStyle.material:
        return MaterialIndicator(
            height: indicator.height ?? 4,
            tabPosition: indicator.tabPosition,
            topRightRadius: indicator.topRightRadius ?? 5,
            topLeftRadius: indicator.topLeftRadius ?? 5,
            bottomRightRadius: indicator.bottomRightRadius ?? 0,
            bottomLeftRadius: indicator.bottomLeftRadius ?? 0,
            color: indicator.color ?? Theme.of(context).primaryColor,
            horizontalPadding: indicator.horizontalPadding ?? 0.0,
            strokeWidth: indicator.strokeWidth ?? 1.0,
            paintingStyle: indicator.paintingStyle ?? PaintingStyle.fill);
      case IndicatorStyle.rectangular:
        return RectangularIndicator(
            topRightRadius: indicator.topRightRadius ?? 5,
            topLeftRadius: indicator.topLeftRadius ?? 5,
            bottomRightRadius: indicator.bottomRightRadius ?? 0,
            bottomLeftRadius: indicator.bottomLeftRadius ?? 0,
            color: indicator.color ?? Theme.of(context).primaryColor,
            horizontalPadding: indicator.horizontalPadding ?? 0.0,
            strokeWidth: indicator.strokeWidth ?? 1.0,
            verticalPadding: indicator.verticalPadding ?? 0.0,
            paintingStyle: indicator.paintingStyle ?? PaintingStyle.fill);
      case IndicatorStyle.none:
      default:
        return const BoxDecoration(color: Colors.transparent);
    }
  }

  Widget _buildTabBar(context) {
    var tabConfig = config.tabBarConfig;

    final colorIcon =
        tabConfig.colorIcon ?? Theme.of(context).colorScheme.secondary;

    final colorActiveIcon =
        tabConfig.colorActiveIcon ?? Theme.of(context).primaryColor;

    var _indicatorSize = tabConfig.indicatorStyle == IndicatorStyle.rectangular
        ? TabBarIndicatorSize.tab
        : TabBarIndicatorSize.label;

    var position = tabConfig.tabBarFloating.position;
    var _floatingIndex = (position != null && position < tabData.length)
        ? position
        : (tabData.length / 2).floor();

    return TabBar(
      key: const Key('mainTabBar'),
      controller: tabController,
      onTap: onTap,
      tabs: [
        for (var i = 0; i < tabData.length; i++)
          TabBarIcon(
            key: Key('TabBarIcon-$i'),
            item: tabData[i],
            totalCart: totalCart,
            isActive: i == tabController.index,
            isEmptySpace: tabConfig.showFloating && i == _floatingIndex,
            config: tabConfig,
          ),
      ],
      isScrollable: false,
      labelColor: colorActiveIcon,
      unselectedLabelColor: colorIcon,
      indicatorSize: _indicatorSize,
      indicatorColor: colorActiveIcon,
      indicator: _buildIndicator(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tabConfig = config.tabBarConfig;

    return Container(
      padding: EdgeInsets.only(
        left: tabConfig.paddingLeft,
        right: tabConfig.paddingRight,
        top: tabConfig.paddingTop,
        bottom: tabConfig.paddingBottom,
      ),
      margin: EdgeInsets.only(
        left: tabConfig.marginLeft,
        right: tabConfig.marginRight,
        bottom: tabConfig.marginBottom,
        top: tabConfig.marginTop,
      ),
      decoration: BoxDecoration(
          color: tabConfig.showFloating
              ? null
              : tabConfig.color ?? Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tabConfig.radiusTopLeft),
            topRight: Radius.circular(tabConfig.radiusTopRight),
            bottomLeft: Radius.circular(tabConfig.radiusBottomLeft),
            bottomRight: Radius.circular(tabConfig.radiusBottomRight),
          ),
          boxShadow: [
            if (!tabConfig.showFloating)
              BoxShadow(
                  spreadRadius: tabConfig.boxShadow?.spreadRadius ?? 0.0,
                  blurRadius: tabConfig.boxShadow?.blurRadius ?? 0.0,
                  offset: Offset(tabConfig.boxShadow?.x ?? 0.0,
                      tabConfig.boxShadow?.y ?? 0.0),
                  color: Colors.grey
                      .withOpacity(tabConfig.boxShadow?.colorOpacity ?? 0.0)),
          ]),
      child: SafeArea(
        bottom: tabConfig.isSafeArea,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutQuint,
          height: isShowDrawer ? 0 : null,
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            border: Border(
              top:
                  BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: !Layout.isDisplayDesktop(context)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: _buildTabBar(context),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 6,
                        child: _buildTabBar(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
