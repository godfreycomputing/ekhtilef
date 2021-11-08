import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart' deferred as defer_icon;
import 'package:inspireui/inspireui.dart' show DeferredWidget, FluxImage;

import '../config/tab_bar_floating_config.dart';
import 'tab_indicator/diamond_border.dart';

class IconFloatingAction extends StatelessWidget {
  final TabBarFloatingConfig config;
  final Function? onTap;
  final Map item;

  const IconFloatingAction({
    Key? key,
    required this.onTap,
    required this.item,
    required this.config,
  }) : super(key: key);

  ShapeBorder shapeBorder() {
    switch (config.floatingType) {
      case FloatingType.diamond:
        return const DiamondBorder();
      default:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.radius ?? 50.0),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = Builder(
      builder: (_context) {
        var iconColor = Colors.white;
        var isImage = item['icon'].contains('/');
        return isImage
            ? FluxImage(imageUrl: item['icon'], color: iconColor, width: 24)
            : DeferredWidget(
                defer_icon.loadLibrary,
                () => Icon(
                    defer_icon.iconPicker(
                      item['icon'],
                      item['fontFamily'],
                    ),
                    color: iconColor,
                    size: 22),
              );
      },
    );

    return RawMaterialButton(
      elevation: config.elevation ?? 4.0,
      shape: shapeBorder(),
      fillColor: config.color ?? Theme.of(context).primaryColor,
      onPressed: () => onTap!(),
      constraints: BoxConstraints.tightFor(
        width: config.width ?? 50.0,
        height: config.height ?? 50.0,
      ),
      child: icon,
    );
  }
}
