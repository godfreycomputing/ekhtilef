import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../generated/l10n.dart';
import '../../models/index.dart' show Blog;
import '../../services/index.dart';

class PostScreen extends StatefulWidget {
  final int? pageId;
  final String? pageTitle;
  final bool isLocatedInTabbar;

  const PostScreen({
    this.pageId,
    this.pageTitle,
    this.isLocatedInTabbar = false,
  });

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final Services _service = Services();
  Future<Blog?>? _getPage;
  final _memoizer = AsyncMemoizer<Blog?>();

  @override
  void initState() {
    // only create the future once
    Future.delayed(Duration.zero, () {
      setState(() {
        _getPage = getPageById(widget.pageId);
      });
    });
    super.initState();
  }

  Future<Blog?> getPageById(context) => _memoizer.runOnce(
        () => _service.api.getPageById(
          widget.pageId,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          widget.pageTitle.toString(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: widget.isLocatedInTabbar
            ? Container()
            : Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
      body: FutureBuilder<Blog?>(
        future: _getPage,
        builder: (BuildContext context, AsyncSnapshot<Blog?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Container(
                  color: Theme.of(context).backgroundColor,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            case ConnectionState.done:
            default:
              if (snapshot.hasError || snapshot.data!.id == null) {
                return Material(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          S.of(context).noPost,
                        ),
                        widget.isLocatedInTabbar
                            ? Container()
                            : TextButton(
                                style: TextButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(S.of(context).goBackHomePage),
                              ),
                      ],
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 0.0,
                ),
                child: PostView(
                  item: snapshot.data,
                ),
              );
          }
        },
      ),
    );
  }
}

class PostView extends StatelessWidget {
  final Blog? item;

  const PostView({this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: HtmlWidget(
        item!.content,
        webView: true,
        webViewJs: true,
        textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontSize: 13.0,
              height: 1.4,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}
