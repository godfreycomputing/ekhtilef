import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../models/app_model.dart';
import '../../../../models/index.dart';
import '../../../../modules/dynamic_layout/helper/custom_physic.dart';
import '../../../../modules/dynamic_layout/helper/header_view.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../screens/index.dart';
import '../../../../services/services.dart';
import '../../../../widgets/blog/blog_card_view.dart';
import 'blog_staggered.dart';

class BlogListLayout extends StatefulWidget {
  final config;

  const BlogListLayout(this.config, {Key? key}) : super(key: key);

  @override
  _ProductListItemsState createState() => _ProductListItemsState();
}

class _ProductListItemsState extends State<BlogListLayout> {
  final Services _service = Services();

  final _listBlogNotifier = ValueNotifier<List<Blog>?>(null);

  final blogEmptyList = const [Blog.empty(1), Blog.empty(2), Blog.empty(3)];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final data = await _service.api.fetchBlogLayout(
        config: widget.config,
        lang: Provider.of<AppModel>(context, listen: false).langCode,
      );
      _listBlogNotifier.value = data ?? [];
    });
  }

  @override
  void dispose() {
    _listBlogNotifier.dispose();
    super.dispose();
  }

  double _buildBlogWidth(screenWidth) {
    switch (widget.config['layout']) {
      case 'twoColumn':
        return screenWidth * 0.5;
      case 'threeColumn':
        return screenWidth / 3;
      case 'fourColumn':
        return screenWidth / 4;
      case 'recentView':
        return screenWidth * 0.35;
      case 'saleOff':
        return screenWidth * 0.35;
      case 'card':
      default:
        return screenWidth - 10;
    }
  }

  Widget getBlogsListWidgets(List<Blog>? blogs, double width, context) {
    final physics = widget.config['isSnapping'] == true
        ? CustomScrollPhysic(width: _buildBlogWidth(width))
        : const ScrollPhysics();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: physics,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          blogs!.length,
          (index) {
            return BlogCard(
              item: blogs[index],
              width: _buildBlogWidth(width),
              onTap: () {
                eventBus.fire(const EventBlogDetailSettings());
                FluxNavigate.pushNamed(
                  RouteList.detailBlog,
                  arguments: BlogDetailArguments(
                    blog: blogs[index],
                    listBlog: blogs,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRecent = widget.config['layout'] == 'recentView' ? true : false;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<List<Blog>?>(
          valueListenable: _listBlogNotifier,
          builder: (context, value, child) {
            if (value == null) {
              return Column(
                children: <Widget>[
                  HeaderView(
                    headerText: widget.config['name'] ?? ' ',
                    showSeeAll: isRecent ? false : true,
                    callback: () => FluxNavigate.pushNamed(
                      RouteList.backdrop,
                      arguments: BackDropArguments(
                        config: widget.config,
                        data: [],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 10.0),
                        for (var i = 0; i < 4; i++)
                          BlogCard(
                            item: Blog.empty(i),
                            width: _buildBlogWidth(
                              constraints.maxWidth,
                            ),
                            onTap: () {},
                          )
                      ],
                    ),
                  )
                ],
              );
            }

            return Column(
              children: <Widget>[
                HeaderView(
                  headerText: widget.config['name'] ?? ' ',
                  showSeeAll: isRecent ? false : true,
                  callback: () => FluxNavigate.pushNamed(
                    RouteList.backdrop,
                    arguments: BackDropArguments(
                      config: widget.config,
                      data: value,
                    ),
                  ),
                ),
                value.isEmpty
                    ? const Text('Getting Error')
                    : (widget.config['layout'] == 'staggered'
                        ? BlogStaggered(value)
                        : getBlogsListWidgets(
                            value,
                            constraints.maxWidth,
                            context,
                          )),
              ],
            );
          },
        );
      },
    );
  }
}
