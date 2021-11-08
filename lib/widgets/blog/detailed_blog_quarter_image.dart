import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/config.dart';
import '../../common/tools.dart';
import '../../models/audio/media_item.dart';
import '../../models/entities/blog.dart';
import '../../models/index.dart' show Blog;
import '../../screens/base_screen.dart';
import '../../services/index.dart';
import 'detailed_blog_mixin.dart';

class OneQuarterImageType extends StatefulWidget {
  final Blog item;

  const OneQuarterImageType({Key? key, required this.item}) : super(key: key);

  @override
  _OneQuarterImageTypeState createState() => _OneQuarterImageTypeState();
}

class _OneQuarterImageTypeState extends BaseScreen<OneQuarterImageType>
    with DetailedBlogMixin {
  ScrollController? _scrollController;
  bool isExpandedListView = true;
  Key key = UniqueKey();

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController!.offset == 0 && !isExpandedListView) {
      setState(() {
        isExpandedListView = true;
      });
    } else {
      if (isExpandedListView) {
        setState(() {
          isExpandedListView = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = widget.item.videoUrl;

    // Widget renderVideoWidget() {
    //   if (videoUrl.isNotEmpty) {
    //     if (!isMobile) {
    //       return const PlatformError();
    //     } else {
    //       return WebView(
    //         key: key,
    //         initialUrl: videoUrl,
    //         javascriptMode: JavascriptMode.unrestricted,
    //       );
    //     }
    //   } else {
    //     return FluxImage(
    //       imageUrl: widget.item.imageFeature,
    //       fit: BoxFit.cover,
    //       height: MediaQuery.of(context).size.height / 3,
    //       width: MediaQuery.of(context).size.width,
    //     );
    //   }
    // }

    return Scaffold(
      body: SafeArea(
        child: AutoHideKeyboard(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: ListView(
                          controller: _scrollController,
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    child: Stack(
                                      children: <Widget>[
                                        ImageTools.image(
                                          url: widget.item.imageFeature,
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          size: kSize.medium,
                                        ),
                                        videoUrl.isNotEmpty
                                            ? WebView(
                                                key: key,
                                                initialUrl: videoUrl,
                                                javascriptMode:
                                                    JavascriptMode.unrestricted,
                                              )
                                            : FluxImage(
                                                imageUrl:
                                                    widget.item.imageFeature,
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 5),
                              child: Text(
                                widget.item.title,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.8),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (widget.item.audioUrls.isNotEmpty &&
                                kBlogDetail['enableAudioSupport'])
                              Services().getAudioBlogCard(
                                widget.item,
                                playItem: (MediaItem mediaItem) => Services()
                                    .playMediaItem(context, mediaItem),
                                addItem: (MediaItem mediaItem) => Services()
                                    .addMediaItemToPlaylist(context, mediaItem),
                                addAll: (Blog blog) => Services()
                                    .addBlogAudioToPlaylist(context, blog),
                              ),
                            renderBlogContentWithTextEnhancement(widget.item),
                            renderRelatedBlog(widget.item.categoryId),
                            renderCommentLayout(widget.item.id),
                            renderCommentInput(widget.item.id),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 90,
                child: AnimatedOpacity(
                  opacity: isExpandedListView ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Card(
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(5.0),
                                child: const Icon(
                                  Icons.person,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'by ${widget.item.author} ',
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.45),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.item.date,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.45),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      margin: const EdgeInsets.all(12.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).backgroundColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_sharp,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  renderBlogFunctionButtons(widget.item),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
