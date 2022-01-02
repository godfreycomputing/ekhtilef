import 'dart:math' as math;
import 'dart:ui';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show AppModel, CartModel, Product, ProductVariation, RecentModel;
import '../../routes/flux_navigate.dart';
import '../../services/service_config.dart';
//import '../common/sale_progress_bar.dart';
//import '../common/start_rating.dart';
import 'dialog_add_to_cart.dart';
//import 'heart_button.dart';
//import 'quantity_selection.dart';

class ProductCard extends StatelessWidget {
  final Product item;
  final double? width;
  final double? maxWidth;
  final double? marginRight;
  final double? radius;
  final kSize size;
  final bool showCart;
  final bool showHeart;
  final bool showProgressBar;
  final height;
  final bool hideDetail;
  final offset;
  final tablet;
  final double? ratioProductImage;
  final bool enableBottomAddToCart;
  final bool showQuantitySelector;

  const ProductCard({
    required this.item,
    this.width,
    this.maxWidth,
    this.size = kSize.medium,
    this.radius,
    this.showHeart = false,
    this.showCart = false,
    this.showProgressBar = false,
    this.showQuantitySelector = false,
    this.height,
    this.offset,
    this.hideDetail = false,
    this.tablet,
    this.marginRight = 6.0,
    this.ratioProductImage = 1.2,
    this.enableBottomAddToCart = false,
  });

  void addToCart(BuildContext context, {int quantity = 1}) {
    final String Function(
            {dynamic context,
            dynamic isSaveLocal,
            Function notify,
            Map<String, dynamic> options,
            Product? product,
            int quantity,
            ProductVariation variation}) addProductToCart =
        Provider.of<CartModel>(context, listen: false).addProductToCart;
    if (enableBottomAddToCart) {
      DialogAddToCart.show(context, product: item);
    } else {
      var message = addProductToCart(
        product: item,
        context: context,
        quantity: quantity,
      );
      _showFlashNotification(item, message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppModel>(context, listen: false).currencyCode;
     final currencyRate = Provider.of<AppModel>(context).currencyRate;
    var salePercent = 0;

    double? regularPrice = 0.0;
    var productImage = width! * (ratioProductImage ?? 1.2);

    // ignore: unrelated_type_equality_checks
    if (item.regularPrice != null &&
        item.regularPrice!.isNotEmpty &&
        item.regularPrice != '0.0') {
      regularPrice = (double.tryParse(item.regularPrice.toString()));
    }

    final gauss = offset != null
        ? math.exp(-(math.pow(offset.abs() - 0.5, 2) / 0.08))
        : 0.0;

    /// Calculate the Sale price
    var isSale = (item.onSale ?? false) &&
        PriceTools.getPriceProductValue(item, currency, onSale: true) !=
            PriceTools.getPriceProductValue(item, currency, onSale: false);
    if (isSale && regularPrice != 0) {
      salePercent =
          (double.parse(item.salePrice!) - regularPrice!) * 100 ~/ regularPrice;
    }

    if (item.type == 'variable') {
      isSale = item.onSale ?? false;
    }

    if (hideDetail) {
      return _buildImageFeature(
        context,
        () => _onTapProduct(context),
      );
    }

    // var priceProduct = PriceTools.getPriceProductValue(
    //   item,
    //   currency,
    //   onSale: true,
    // );

    /// Sold by widget
    var _soldByStore = item.store != null && item.store!.name != ''
        ? Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Text(
              S.of(context).soldBy + ' ' + item.store!.name!,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          )
        : const SizedBox();

    /// product name
    // Widget _productTitle = Text(
    //   '${item.name!}\n',
    //   style: Theme.of(context).textTheme.subtitle1!.apply(
    //         fontSizeFactor: 0.9,
    //       ),
    //   maxLines: 2,
    // );

    // /// Show Cart button
    // var _quantity = 1;
    // var _cartIcon = IconButton(
    //   iconSize: 18.0,
    //   constraints: showQuantitySelector ? const BoxConstraints() : null,
    //   icon: const Icon(
    //     Icons.add_shopping_cart,
    //   ),
    //   onPressed: () => addToCart(context, quantity: _quantity),
    // );

    // var _canAddToCart = item.canBeAddedToCartFromList;

    // var _showCart = (showCart && _canAddToCart && !showQuantitySelector)
    //     ? _cartIcon
    //     : const SizedBox(width: 30, height: 30);

    // /// Product Pricing
    // Widget _productPricing = Wrap(
    //   crossAxisAlignment: WrapCrossAlignment.center,
    //   children: <Widget>[
    //     Text(
    //       item.type == 'grouped'
    //           ? '${S.of(context).from} ${PriceTools.getPriceProduct(item, currencyRate, currency, onSale: true)}'
    //           : priceProduct == '0.0'
    //               ? S.of(context).loading
    //               : Config().isListingType
    //                   ? PriceTools.getCurrencyFormatted(
    //                       item.price ?? item.regularPrice ?? '0', null)!
    //                   : PriceTools.getPriceProduct(item, currencyRate, currency,
    //                       onSale: true)!,
    //       style: Theme.of(context)
    //           .textTheme
    //           .headline6!
    //           .copyWith(
    //             fontWeight: FontWeight.w600,
    //           )
    //           .apply(fontSizeFactor: 0.8),
    //     ),

    //     /// Not show regular price for variant product (product.regularPrice = "").
    //     if (isSale && item.type != 'variable') ...[
    //       const SizedBox(width: 5),
    //       Text(
    //         item.type == 'grouped'
    //             ? ''
    //             : PriceTools.getPriceProduct(item, currencyRate, currency,
    //                 onSale: false)!,
    //         style: Theme.of(context)
    //             .textTheme
    //             .caption!
    //             .copyWith(
    //               fontWeight: FontWeight.w300,
    //               color:
    //                   Theme.of(context).colorScheme.secondary.withOpacity(0.6),
    //               decoration: TextDecoration.lineThrough,
    //             )
    //             .apply(fontSizeFactor: 0.8),
    //       ),
    //     ],
    //   ],
    // );

    /// Product Stock Status
    // var _stockStatus = _buildStockStatus(context);

    // /// product rating, Hide rating for onSale layout.
    // var _rating = (kAdvanceConfig['EnableRating'] ?? false) &&
    //         (kAdvanceConfig['hideEmptyProductListRating'] == false ||
    //             (item.ratingCount != null && item.ratingCount! > 0)) &&
    //         !(showProgressBar)
    //     ? SmoothStarRating(
    //         allowHalfRating: true,
    //         starCount: 5,
    //         rating: item.averageRating ?? 0.0,
    //         size: 10.0,
    //         color: kColorRatingStar,
    //         borderColor: kColorRatingStar,
    //         label: Text(
    //           item.ratingCount == 0 || item.ratingCount == null
    //               ? ''
    //               : '${item.ratingCount}',
    //           style: Theme.of(context)
    //               .textTheme
    //               .caption!
    //               .apply(fontSizeFactor: 0.7),
    //         ),
    //         spacing: 0.0)
    //     : const SizedBox();

    /// Show Stock status & Rating
    // Widget _productStockRating = StatefulBuilder(
    //   builder: (_, StateSetter setState) {
    //     return Align(
    //       alignment: Alignment.bottomLeft,
    //       child: Stack(
    //         children: [
    //           Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     _stockStatus,
    //                     _rating,
    //                     if (showQuantitySelector && showCart && _canAddToCart)
    //                       Padding(
    //                         padding: const EdgeInsets.only(top: 5.0),
    //                         child: Row(
    //                           mainAxisSize: MainAxisSize.max,
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             QuantitySelection(
    //                               width: 50,
    //                               height: 30,
    //                               color:
    //                                   Theme.of(context).colorScheme.secondary,
    //                               limitSelectQuantity:
    //                                   kCartDetail['maxAllowQuantity'] ?? 100,
    //                               value: _quantity,
    //                               onChanged: (int value) {
    //                                 setState(() {
    //                                   _quantity = value;
    //                                 });
    //                               },
    //                               useNewDesign: true,
    //                             ),
    //                             const Spacer(),
    //                             // _cartIcon,
    //                           ],
    //                         ),
    //                       ),
    //                     const SizedBox(height: 4),
    //                   ],
    //                 ),
    //               ),
    //               const SizedBox(width: 10),
    //             ],
    //           ),
    //           Positioned(
    //             left:
    //                 Directionality.of(context) == TextDirection.rtl ? 0 : null,
    //             right:
    //                 Directionality.of(context) == TextDirection.rtl ? null : 0,
    //             top: -14,
    //             child: _showCart,
    //           )
    //         ],
    //       ),
    //     );
    //   },
    // );

    Widget _productImage = Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(4),
          //margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.8),
                offset: const Offset(0.5, 7),
                blurRadius: 6.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20
                //((radius ?? kProductCard['borderRadius'] ?? 3) * 0.7),
                ),
            child: Container(
              constraints: BoxConstraints(maxHeight: productImage * .59),
              child: Transform.translate(
                offset: Offset(18 * gauss, 0.0),
                child: _buildImageFeature(
                  context,
                  () => _onTapProduct(context),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: SizedBox(
            width: 150,
            child: Text(item.name!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ],

      /// Not show sale percent for variant product (product.regularPrice = "").
      // if (isSale &&
      //     (item.regularPrice?.isNotEmpty ?? false) &&
      //     regularPrice != null &&
      //     regularPrice != 0.0 &&
      //     item.type != 'variable')
      //   Positioned(
      //     left: 0,
      //     top: 0,
      //     child: Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      //       decoration: BoxDecoration(
      //         color: Colors.redAccent,
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(radius ?? 0.0),
      //           bottomRight: Radius.circular(radius ?? 12),
      //         ),
      //       ),
      //       child: Text(
      //         '$salePercent%',
      //         style: Theme.of(context)
      //             .textTheme
      //             .caption!
      //             .copyWith(
      //               fontWeight: FontWeight.w700,
      //               color: Colors.white,
      //             )
      //             .apply(fontSizeFactor: 0.9),
      //       ),
      //     ),
      //   ),

      /// Show On Sale label for variant product.
      // if (isSale && item.type == 'variable')
      //   Align(
      //     alignment: Alignment.topLeft,
      //     child: Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //       decoration: BoxDecoration(
      //         color: Colors.redAccent,
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(radius ?? 0.0),
      //           bottomRight: Radius.circular(radius ?? 8),
      //         ),
      //       ),
      //       child: Text(
      //         S.of(context).onSale,
      //         style: const TextStyle(
      //             fontSize: 12,
      //             fontWeight: FontWeight.w600,
      //             color: Colors.white),
      //       ),
      //     ),
      //   ),
    );

    Widget _productInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        //if (!(kProductCard['hideTitle'] ?? false)) _productTitle,
        if (!(kProductCard['hideStore'] ?? false)) _soldByStore,
        const SizedBox(height: 5),
        // if (!(kProductCard['hidePrice'] ?? false))
        //   Row(
        //     children: [
        //       Expanded(child: _productPricing),
        //     ],
        //   ),
        const SizedBox(height: 2),
        //_productStockRating,
      ],
    );

    return GestureDetector(
      onTap: () => _onTapProduct(context),
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? width!),
            width: width!,
            decoration: BoxDecoration(
              boxShadow: [
                if (kProductCard['boxShadow'] != null) //YAJAR
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(
                      kProductCard['boxShadow']['x'] ?? 0,
                      kProductCard['boxShadow']['y'] ?? 1,
                    ),
                    blurRadius: kProductCard['boxShadow']['blurRadius'] ?? 2,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  radius ?? kProductCard['borderRadius'] ?? 3),
              child: Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                      Theme.of(context).cardColor,
                      Theme.of(context).backgroundColor,
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _productImage,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: _productInfo,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // if (showHeart && !item.isEmptyProduct())
          //   Positioned(
          //     top: 5,
          //     right: 5,
          //     child: HeartButton(product: item, size: 18),
          //   )
        ],
      ),
    );
  }

  Widget _buildImageFeature(context, onTapProduct) {
    if (item.imageFeature != null &&
        item.imageFeature!.contains('placeholder')) {
      return Container(
        height: double.infinity * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(radius ?? 6),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Text(
          item.name!,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: onTapProduct,
      child: ImageTools.image(
        url: item.imageFeature,
        width: width,
        size: kSize.medium,
        isResize: true,
        fit: kCardFit,
        offset: offset ?? 0.0,
      ),
    );
  }

  void _onTapProduct(context) {
    // if (item.imageFeature == '') return;
    // Provider.of<RecentModel>(context, listen: false).addRecentProduct(item);
    // //Load update product detail screen for FluxBuilder
    // eventBus.fire(const EventDetailSettings());
    FluxNavigate.pushNamed(
      RouteList.productDetail,
      arguments: item,
    );
  }

  void _showFlashNotification(Product? product, String message, context) {
    if (message.isNotEmpty) {
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        persistent: !Config().isBuilder,
        builder: (context, controller) {
          return Flash(
            borderRadius: BorderRadius.circular(3.0),
            backgroundColor: Theme.of(context).errorColor,
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              content: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      );
    } else {
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        persistent: !Config().isBuilder,
        builder: (context, controller) {
          return Flash(
            borderRadius: BorderRadius.circular(3.0),
            backgroundColor: Theme.of(context).primaryColor,
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              title: Text(
                product!.name!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ),
              content: Text(
                S.of(context).addToCartSucessfully,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  // Widget _buildStockStatus(BuildContext context) {
  //   if (showProgressBar) {
  //     return SaleProgressBar(width: width, product: item);
  //   }

  //   return ((kAdvanceConfig['showStockStatus'] ?? false) &&
  //           !item.isEmptyProduct())
  //       ? item.backOrdered
  //           ? Text(
  //               S.of(context).backOrder,
  //               style: const TextStyle(
  //                 color: kColorBackOrder,
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 12,
  //               ),
  //             )
  //           : item.inStock != null
  //               ? Text(
  //                   item.inStock!
  //                       ? S.of(context).inStock
  //                       : S.of(context).outOfStock,
  //                   style: TextStyle(
  //                     color: item.inStock! ? kColorInStock : kColorOutOfStock,
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 12,
  //                   ),
  //                 )
  //               : const SizedBox()
  //       : const SizedBox();
  //}
}
