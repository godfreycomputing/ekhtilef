import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/tools.dart';
import '../../models/entities/blog.dart';
import 'detailed_blog_mixin.dart';

class BlogDetail extends StatefulWidget {
  final Blog item;

  const BlogDetail({Key? key, required this.item}) : super(key: key);

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogDetail> with DetailedBlogMixin {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    const bannerHigh = 180.0;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      48,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),
            ),
            actions: [
              renderBlogFunctionButtons(widget.item),
            ],
            expandedHeight: bannerHigh,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ImageTools.image(
                url: item.imageFeature,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                size: kSize.medium,
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.title,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
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
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.date,
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
                              const SizedBox(height: 5.0),
                              Text(
                                'by ${item.author}',
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
                        ],
                      ),
                      renderBlogContentWithTextEnhancement(widget.item),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
