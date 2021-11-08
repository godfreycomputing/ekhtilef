import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show Skeleton;
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/blog.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/index.dart';
import '../../../widgets/common/paging_list.dart';
import '../../base_screen.dart';
import '../models/list_blog_model.dart';
import 'blog_detail_screen.dart';
import 'widgets/blog_list_item.dart';

class ListBlogScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListBlogScreenState();
}

class _ListBlogScreenState extends BaseScreen<ListBlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !kIsWeb
          ? AppBar(
              elevation: 0.1,
              title: Text(
                S.of(context).blog,
                style: const TextStyle(color: Colors.white),
              ),
              leading: Config().isBuilder
                  ? const SizedBox()
                  : Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
            )
          : null,
      body: PagingList<ListBlogModel, Blog>(
        itemBuilder: (context, blog, _) => BlogListItem(
            blog: blog,
            onTap: () {
              eventBus.fire(const EventBlogDetailSettings());
              FluxNavigate.pushNamed(
                RouteList.detailBlog,
                arguments: BlogDetailArguments(
                  blog: blog,
                  listBlog:
                      Provider.of<ListBlogModel>(context, listen: false).data,
                ),
              );
            }),
        loadingWidget: _buildSkeleton(),
        lengthLoadingWidget: 3,
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 24.0,
        top: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Skeleton(height: 200),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Skeleton(width: 120),
              Skeleton(width: 80),
            ],
          ),
          const SizedBox(height: 16),
          const Skeleton(),
        ],
      ),
    );
  }
}
