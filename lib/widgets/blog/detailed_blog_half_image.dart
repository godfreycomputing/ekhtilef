import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/tools.dart';
import '../../models/entities/blog.dart';
import 'detailed_blog_mixin.dart';

class HalfImageType extends StatefulWidget {
  final Blog item;

  const HalfImageType({Key? key, required this.item}) : super(key: key);

  @override
  _HalfImageTypeState createState() => _HalfImageTypeState();
}

class _HalfImageTypeState extends State<HalfImageType> with DetailedBlogMixin {
  bool isFBNativeBannerAdShown = false;
  bool isFBNativeAdShown = false;
  bool isFBBannerShown = false;

  @override
  void initState() {
    if (kAdConfig['enable'] ?? false) {
      // _initAds();
    }
    super.initState();
  }

  Widget _buildChildWidgetAd() {
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: ImageTools.image(
                  url: widget.item.imageFeature,
                  fit: BoxFit.fitHeight,
                  size: kSize.medium,
                )),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                actions: [
                  renderBlogFunctionButtons(widget.item),
                ],
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                              topRight: Radius.circular(35.0),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                  top: 30.0,
                                ),
                                child: Text(
                                  widget.item.title,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).primaryColorLight,
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
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                .secondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.item.date,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              renderBlogContentWithTextEnhancement(widget.item),
                              renderRelatedBlog(widget.item.categoryId),
                              renderCommentLayout(widget.item.id),
                              renderCommentInput(widget.item.id),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (kAdConfig['enable'] ?? false)
              Container(
                alignment: Alignment.bottomCenter,
                child: _buildChildWidgetAd(),
              ),
          ],
        ),
      ),
    );
  }
}
