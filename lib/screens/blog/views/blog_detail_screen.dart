import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../models/app_model.dart';
import '../../../models/entities/blog.dart';
import '../../../widgets/blog/detailed_blog_fullsize_image.dart';
import '../../../widgets/blog/detailed_blog_half_image.dart';
import '../../../widgets/blog/detailed_blog_quarter_image.dart';
import '../../../widgets/blog/detailed_blog_view.dart';
import '../models/list_blog_model.dart';

class BlogDetailArguments {
  final Blog blog;
  final List<Blog>? listBlog;

  BlogDetailArguments({
    required this.blog,
    this.listBlog,
  });
}

class BlogDetailScreen extends StatefulWidget {
  final Blog blog;
  final List<Blog>? listBlog;
  const BlogDetailScreen({required this.blog, this.listBlog});

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  PageController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listBlog = widget.listBlog ?? [];
    if (listBlog.isNotEmpty) {
      controller ??= PageController(
          initialPage:
              listBlog.indexWhere((element) => element.id == widget.blog.id));
      return Stack(
        children: [
          PageView.builder(
            itemCount: listBlog.length,
            controller: controller,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return getDetailScreen(listBlog[index]);
            },
          ),
          // if (kBlogDetail['enableAudioSupport'] ?? false)
          //   Positioned(
          //     bottom: 0,
          //     child: _StickyAudioPlayer(context),
          //   ),
        ],
      );
    } else {
      return getDetailScreen(widget.blog);
    }
  }

  Widget getDetailScreen(Blog blog) {
    if (Videos.getVideoLink(blog.content) != null) {
      return OneQuarterImageType(item: blog);
    } else {
      var blogLayout = Provider.of<AppModel>(context).blogDetailLayout;
      switch (blogLayout) {
        case kBlogLayout.halfSizeImageType:
          return HalfImageType(item: blog);
        case kBlogLayout.fullSizeImageType:
          return FullImageType(item: blog);
        case kBlogLayout.oneQuarterImageType:
          return OneQuarterImageType(item: blog);
        default:
          return BlogDetail(item: blog);
      }
    }
  }
}

// Widget _StickyAudioPlayer(BuildContext context) {
//   return Consumer<AudioModel>(builder: (context, value, child) {
//     final active = value.isStickyAudioWidgetActive;
//     return Visibility(
//       visible: active,
//       child: Container(
//         decoration: const BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: Colors.black12,
//               width: 1.0,
//             ),
//           ),
//         ),
//         width: MediaQuery.of(context).size.width,
//         height: 130,
//         child: const Card(
//           margin: EdgeInsets.zero,
//           child: AudioWidget(),
//         ),
//       ),
//     );
//   });
// }
