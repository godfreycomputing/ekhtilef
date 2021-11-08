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
import 'dialog_add_to_cart.dart';
import 'heart_button.dart';

class ProductGlass extends StatelessWidget {
  final Product item;
  final double? width;
  final double? maxWidth;
  final double? marginRight;
  final double? radius;
  final kSize size;
  final bool showCart;
  final bool showHeart;
  final bool showProgressBar;
  final bool showShortDescription;
  final height;
  final bool hideDetail;
  final offset;
  final tablet;
  final double? ratioProductImage;
  final bool enableBottomAddToCart;
  final bool showQuantitySelector;

  const ProductGlass({
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
    this.showShortDescription = false,
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

    var priceProduct = PriceTools.getPriceProductValue(
      item,
      currency,
      onSale: true,
    );

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

    /// Product name.
    Widget _productTitle = Text(
      item.name!,
      style: Theme.of(context).textTheme.subtitle1!.apply(
            fontSizeFactor: 0.9,
          ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );

    /// Product short description.
    var _productShortDescription = showShortDescription
        ? Text(
            item.shortDescription ?? '',
            style: Theme.of(context).textTheme.caption!.apply(
                  fontSizeFactor: 0.8,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : const SizedBox();

    /// Show Cart button
    var _quantity = 1;
    var _cartIcon = Container(
      height: 36.0,
      width: 36.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((radius ?? 0.0) * 0.3),
        color: Theme.of(context).primaryColor,
      ),
      child: IconButton(
        onPressed: () => addToCart(context, quantity: _quantity),
        icon: const Icon(
          Icons.add,
          size: 18.0,
        ),
      ),
    );

    var _canAddToCart = item.canBeAddedToCartFromList;

    var _showCart = (showCart && _canAddToCart && !showQuantitySelector)
        ? _cartIcon
        : const SizedBox(width: 30, height: 30);

    /// Product Pricing
    Widget _productPricing = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          item.type == 'grouped'
              ? '${S.of(context).from} ${PriceTools.getPriceProduct(item, currencyRate, currency, onSale: true)}'
              : priceProduct == '0.0'
                  ? S.of(context).loading
                  : Config().isListingType
                      ? PriceTools.getCurrencyFormatted(
                          item.price ?? item.regularPrice ?? '0', null)!
                      : PriceTools.getPriceProduct(item, currencyRate, currency,
                          onSale: true)!,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(
                fontWeight: FontWeight.w600,
              )
              .apply(fontSizeFactor: 0.8),
        ),

        /// Not show regular price for variant product (product.regularPrice = "").
        if (isSale && item.type != 'variable') ...[
          const SizedBox(width: 5),
          Text(
            item.type == 'grouped'
                ? ''
                : PriceTools.getPriceProduct(item, currencyRate, currency,
                    onSale: false)!,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(
                  fontWeight: FontWeight.w300,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  decoration: TextDecoration.lineThrough,
                )
                .apply(fontSizeFactor: 0.8),
          ),
        ],
      ],
    );

    var _ratingText = Row(
      children: [
        Icon(
          Icons.star,
          color: Theme.of(context).primaryColor,
          size: Theme.of(context).textTheme.caption!.fontSize,
        ),
        Text(
          '${item.averageRating ?? 0.0}',
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )
              .apply(fontSizeFactor: 0.9),
        ),
      ],
    );

    /// product rating, Hide rating for onSale layout.
    var _rating = (kAdvanceConfig['EnableRating'] ?? false) &&
            (kAdvanceConfig['hideEmptyProductListRating'] == false ||
                (item.ratingCount != null && item.ratingCount! > 0)) &&
            !(showProgressBar)
        ? Stack(
            children: [
              Positioned(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          radius != null ? (radius! * 0.7) : 12),
                    ),
                  ),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 20.0,
                      sigmaY: 20.0,
                    ),
                    child: _ratingText,
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: _ratingText,
                ),
              ),
            ],
          )
        : const SizedBox();

    Widget _productImage = Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(
              ((radius ?? kProductCard['borderRadius'] ?? 3) * 0.7)),
          child: Stack(
            children: [
              Positioned(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: productImage),
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
                top: 0.0,
                right: 0.0,
                child: _rating,
              ),

              /// Not show sale percent for variant product (product.regularPrice = "").
              if (isSale &&
                  (item.regularPrice?.isNotEmpty ?? false) &&
                  regularPrice != null &&
                  regularPrice != 0.0 &&
                  item.type != 'variable')
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(radius ?? 12),
                      ),
                    ),
                    child: Text(
                      '$salePercent%',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )
                          .apply(fontSizeFactor: 0.9),
                    ),
                  ),
                ),

              /// Show On Sale label for variant product.
              if (isSale && item.type == 'variable')
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(radius ?? 8),
                      ),
                    ),
                    child: Text(
                      S.of(context).onSale,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    Widget _productInfo = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (!(kProductCard['hideTitle'] ?? false)) _productTitle,
        if (item.shortDescription?.isNotEmpty ?? false)
          _productShortDescription,
        if (!(kProductCard['hideStore'] ?? false)) _soldByStore,
        const SizedBox(height: 5),
        if (!(kProductCard['hidePrice'] ?? false))
          Row(
            children: [
              Expanded(child: _productPricing),
              _showCart,
            ],
          ),
      ],
    );

    return GestureDetector(
      onTap: () => _onTapProduct(context),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? width!),
            width: width!,
            decoration: BoxDecoration(
              boxShadow: [
                if (kProductCard['boxShadow'] != null)
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
                      Theme.of(context).primaryColor.withOpacity(0.5),
                      Theme.of(context).backgroundColor,
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Container(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _productImage,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              (radius ?? kProductCard['borderRadius'] ?? 6) *
                                  0.25,
                        ),
                        child: _productInfo,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (showHeart && !item.isEmptyProduct())
            Positioned(
              top: 5,
              right: 5,
              child: HeartButton(product: item, size: 18),
            )
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
    if (item.imageFeature == '') return;
    Provider.of<RecentModel>(context, listen: false).addRecentProduct(item);
    //Load update product detail screen for FluxBuilder
    eventBus.fire(const EventDetailSettings());
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
}
