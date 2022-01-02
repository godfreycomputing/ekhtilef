import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/entities/index.dart';
import '../../../../../modules/dynamic_layout/helper/header_view.dart';
import '../../../../../routes/flux_navigate.dart';
import 'menu_layout.dart';
import 'pinterest_layout.dart';
import 'vertical_layout.dart';

class VerticalLayout extends StatefulWidget {
  final config;

  const VerticalLayout({this.config, Key? key}) : super(key: key);

  @override
  _VerticalLayoutState createState() => _VerticalLayoutState();
}

class _VerticalLayoutState extends State<VerticalLayout> {
  Widget renderLayout() {
    switch (widget.config['layout']) {
      case 'menu':
        return MenuLayout(config: widget.config);
      case 'pinterest':
        return PinterestLayout(config: widget.config);
      default:
        return VerticalViewLayout(config: widget.config);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (widget.config['name'] != null)
          HeaderView(
            headerText: widget.config['name']  ?? '',
            showSeeAll: true,
            callback: () => FluxNavigate.pushNamed(
              RouteList.backdrop,
              arguments: BackDropArguments(
                config: widget.config,
              ),
            ),
          ),
        renderLayout()
      ],
    );
  }
}
