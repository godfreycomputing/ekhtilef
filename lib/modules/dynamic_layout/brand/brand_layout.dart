import 'package:flutter/material.dart';
import 'package:inspireui/widgets/flux_image.dart';
import 'package:inspireui/widgets/skeleton_widget/skeleton_widget.dart';

import '../../../common/constants.dart';
import '../../../models/entities/back_drop_arguments.dart';
import '../../../models/entities/brand.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/index.dart';
import '../config/brand_config.dart';
import '../helper/header_view.dart';

class BrandLayout extends StatefulWidget {
  final BrandConfig? config;

  const BrandLayout({this.config});

  @override
  _BrandLayoutState createState() => _BrandLayoutState();
}

class _BrandLayoutState extends State<BrandLayout> {
  final Services _service = Services();
  final _listBrandNotifier = ValueNotifier<List<Brand>?>(null);
  final _pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final data = await _service.api.getBrands();
      _listBrandNotifier.value = data ?? [];
    });
    super.initState();
  }

  @override
  void dispose() {
    _listBrandNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  final brandEmptyList = [Brand.empty(1), Brand.empty(2), Brand.empty(3)];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Brand>?>(
        valueListenable: _listBrandNotifier,
        builder: (context, value, child) {
          if (value == null) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: HeaderView(
                      headerText: widget.config!.name ?? ' ',
                      verticalMargin: 4,
                      showSeeAll: false),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12.0,
                      ),
                      ...List.filled(
                        5,
                        _BrandItemSkeleton(),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: HeaderView(
                    headerText: widget.config!.name ?? ' ',
                    verticalMargin: 4,
                    showSeeAll: false),
              ),
              Container(
                color: Theme.of(context).backgroundColor,
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 12.0,
                      ),
                      for (var i = 0; i < value.length; i++)
                        _BrandItem(
                          brand: value[i],
                          onTap: () => FluxNavigate.pushNamed(
                            RouteList.backdrop,
                            arguments: BackDropArguments(
                              config: widget.config,
                              brandId: value[i].id,
                              brandName: value[i].name,
                              brandImg: value[i].image,
                              // data: snapshot.data,
                            ),
                          ),
                          isBrandNameShown: widget.config!.isBrandNameShown,
                          isLogoCornerRounded:
                              widget.config!.isLogoCornerRounded,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class _BrandItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Skeleton(
              height: 60,
              width: 60,
            ),
            Skeleton(
              height: 20,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandItem extends StatelessWidget {
  final Brand? brand;
  final onTap;
  final isBrandNameShown;
  final isLogoCornerRounded;

  const _BrandItem(
      {this.brand,
      this.onTap,
      this.isBrandNameShown = true,
      this.isLogoCornerRounded = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: isLogoCornerRounded
                  ? const BorderRadius.all(
                      Radius.circular(15.0),
                    )
                  : BorderRadius.zero,
              child: FluxImage(
                imageUrl: brand!.image!,
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isBrandNameShown
                ? Text(
                    brand!.name!,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.caption,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
