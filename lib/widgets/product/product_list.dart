import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/config.dart' show kProductDetail;
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../common/tools/adaptive_tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Product;
import '../../modules/dynamic_layout/vertical/pinterest_card.dart';
import '../../services/index.dart';
import '../backdrop/backdrop_constants.dart';
import '../common/no_internet_connection.dart';
import 'product_item_tile.dart';

class ProductList extends StatefulWidget {
  final List<Product>? products;
  final bool isFetching;
  final bool? isEnd;
  final String? errMsg;
  final width;
  final padding;
  final String? layout;
  final Function onRefresh;
  final Function onLoadMore;
  final double? ratioProductImage;
  final bool showProgressBar;

  const ProductList({
    this.isFetching = false,
    this.isEnd = true,
    this.errMsg,
    this.products,
    this.width,
    this.padding = 8.0,
    required this.onRefresh,
    required this.onLoadMore,
    this.layout = 'list',
    this.ratioProductImage,
    this.showProgressBar = false,
  });

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late RefreshController _refreshController;
  List<Product> emptyList = [
    Product.empty('1'),
    Product.empty('2'),
    Product.empty('3'),
    Product.empty('4'),
    Product.empty('5'),
    Product.empty('6')
  ];

  @override
  void initState() {
    super.initState();

    /// if there are existing product from previous navigate we don't need to enable the refresh
    _refreshController = RefreshController(initialRefresh: false);
  }

  void _onRefresh() async {
    if (!widget.isFetching) {
      widget.onRefresh();
    }
    _refreshController.loadComplete();
  }

  void _onLoading() async {
    if (!widget.isFetching && !widget.isEnd!) {
      await widget.onLoadMore();
    }
    _refreshController.loadComplete();
  }

  @override
  void didUpdateWidget(ProductList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFetching == false && oldWidget.isFetching == true) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printLog('[🟢 build product_list]');

    final screenSize = MediaQuery.of(context).size;
    final isTablet = Tools.isTablet(MediaQuery.of(context));

    var widthScreen = widget.width ?? screenSize.width;
    var widthContent = screenSize.width;
    var crossAxisCount = 1;
    var childAspectRatio = 0.8;

    if (isDisplayDesktop(context)) {
      widthScreen -= BackdropConstants.drawerWidth;
    }
    if (widget.layout == 'card') {
      crossAxisCount = isTablet ? 2 : 1;
      widthContent = isTablet ? widthScreen / 2 : widthScreen; //one column
    } else if (widget.layout == 'columns') {
      crossAxisCount = isTablet ? 4 : 3;
      widthContent =
          isTablet ? widthScreen / 4 : (widthScreen / 3); //three columns
    } else if (widget.layout == 'listTile') {
      crossAxisCount = isTablet ? 2 : 1;
      widthContent = widthScreen; // one column
    } else {
      /// 2 columns on mobile, 3 columns on ipad
      crossAxisCount = isTablet ? 3 : 2;
      //layout is list
      widthContent =
          isTablet ? widthScreen / 3 : (widthScreen / 2); //two columns
    }
    var itemHeight = kProductDetail.productListItemHeight;
    if (kProductDetail.showQuantityInList) {
      itemHeight += 30;
    }

    childAspectRatio = (isTablet ? 0.94 : 1) *
        widthContent /
        (widthContent * (widget.ratioProductImage ?? 1.2) + itemHeight);

    final hasNoProduct = widget.products == null || widget.products!.isEmpty;

    final productsList =
        hasNoProduct && widget.isFetching ? emptyList : widget.products;

    if (hasNoProduct &&
        widget.errMsg != null &&
        widget.errMsg!.isNoInternetError) {
      return NoInternetConnection(onRefresh: _onRefresh);
    }

    if (productsList == null || productsList.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noProduct,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }

    Widget typeList = const SizedBox();

    if (widget.layout != 'pinterest') {
      if (widget.layout == 'listTile') {
        typeList = buildListView(products: productsList);
      } else {
        typeList = buildGridViewProduct(
          childAspectRatio: childAspectRatio,
          crossAxisCount: crossAxisCount,
          products: productsList,
          widthContent: widthContent,
        );
      }
    } else {
      typeList = buildStaggeredGridView(
        products: productsList,
        widthContent: widthScreen,
      );
    }

    return SmartRefresher(
      header: MaterialClassicHeader(
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      enablePullDown: true,
      enablePullUp: !widget.isEnd!,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      footer: kCustomFooter(context),
      child: typeList,
    );
  }

  Widget buildGridViewProduct({
    required int crossAxisCount,
    required double childAspectRatio,
    double? widthContent,
    required List<Product> products,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      cacheExtent: 500.0,
      itemCount: products.length,
      itemBuilder: (context, i) {
        return Services().widget.renderProductCardView(
              item: products[i],
              showCart: widget.layout != 'columns' &&
                  products[i].canBeAddedToCartFromList,
              showHeart: true,
              width: widthContent,
              ratioProductImage: widget.ratioProductImage,
              marginRight: widget.layout == 'card' ? 0.0 : 10.0,
              showProgressBar: widget.showProgressBar,
              showQuantitySelector: kProductDetail.showQuantityInList,
            );
      },
    );
  }

  Widget buildStaggeredGridView({
    required List<Product>? products,
    double? widthContent,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 4.0,
      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 8.0,
      padding: const EdgeInsets.only(
        bottom: 32,
        left: 8,
        right: 8,
      ),
      itemCount: products!.length,
      itemBuilder: (context, index) => PinterestCard(
        item: products[index],
        showOnlyImage: false,
        width: MediaQuery.of(context).size.width / 2,
        showCart: widget.layout != 'columns' &&
            products[index].canBeAddedToCartFromList,
      ),
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
    );
  }

  Widget buildListView({
    required List<Product>? products,
  }) {
    return ListView.builder(
      itemCount: products!.length,
      itemBuilder: (_, index) => ProductItemTileView(
        item: products[index],
        padding: const EdgeInsets.only(),
        showProgressBar: widget.showProgressBar,
      ),
    );
  }
}