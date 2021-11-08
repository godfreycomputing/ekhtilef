import 'package:flutter/material.dart';

import '../../common/tools.dart';
import '../../models/index.dart' show Blog;

class BlogCard extends StatelessWidget {
  final Blog? item;
  final width;
  final margin;
  final kSize size;
  final height;
  final VoidCallback onTap;

  const BlogCard({
    this.item,
    this.width,
    this.size = kSize.medium,
    this.height,
    this.margin = 5.0,
    required this.onTap,
  });

  Widget getImageFeature(double imageWidth) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: ImageTools.image(
          url: item!.imageFeature,
          width: imageWidth,
          height: height ?? width * 0.45,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    var titleFontSize = isTablet ? 20.0 : 14.0;
    const padding = 15.0;
    var maxWidth = width - padding;

    return Container(
      padding: const EdgeInsets.only(left: padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getImageFeature(maxWidth),
          Container(
            width: maxWidth,
            padding:
                const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item!.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item!.date,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
