import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../models/entities/blog.dart';

class BlogGridItem extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;
  final double radius;
  final double innerPadding;
  final Color background;
  final Color itemBackgroundColor;

  const BlogGridItem({
    required this.blog,
    required this.onTap,
    this.radius = 0.0,
    this.innerPadding = 0.0,
    this.background = Colors.transparent,
    this.itemBackgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getValueForScreenType<double>(
          context: context,
          mobile: 90 + innerPadding,
          tablet: 120 + innerPadding,
          desktop: 180 + innerPadding,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 6,
            left: Directionality.of(context) == TextDirection.ltr ? 0 : 16,
            right: Directionality.of(context) == TextDirection.ltr ? 16 : 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: itemBackgroundColor,
            ),
            padding: EdgeInsets.all(innerPadding),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        radius * 0.7,
                      ),
                      child: FluxImage(
                        imageUrl: blog.imageFeature,
                        fit: BoxFit.fitWidth,
                        // isVideo: blog.videoUrl.isNotEmpty,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          blog.title,
                          maxLines: 2,
                        ),
                        if (blog.date.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              blog.date,
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
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
    );
  }
}
