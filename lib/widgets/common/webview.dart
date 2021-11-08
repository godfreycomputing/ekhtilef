import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../common/config.dart';

class WebView extends StatefulWidget {
  final String? url;
  final String? title;

  const WebView({Key? key, this.title, required this.url}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url!,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        title: Text(
          widget.title ?? '',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      withZoom: true,
      withLocalStorage: true,
      initialChild: kLoadingWidget(context),
    );
  }
}
