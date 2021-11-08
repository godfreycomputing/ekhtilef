import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../common/tools/flash.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show AppModel, CartModel, Product, ProductVariation;
import '../../../routes/flux_navigate.dart';

enum SimpleListType { backgroundColor, priceOnTheRight }

class SimpleListView extends StatelessWidget {
  final Product? item;
  final SimpleListType? type;

  const SimpleListView({this.item, this.type});

  @override
  Widget build(BuildContext context) {
    if (item?.name == null) return const SizedBox();

    final currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleFontSize = 15.0;
    var imageWidth = 60.0;
    var imageHeight = 60.0;

    final theme = Theme.of(context);

    var isSale = (item!.onSale ?? false) &&
        PriceTools.getPriceProductValue(item, currency, onSale: true) !=
            PriceTools.getPriceProductValue(item, currency, onSale: false);
    if (item!.type == 'variable') {
      isSale = item!.onSale ?? false;
    }

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
      var message = addProductToCart(
        product: item,
        context: context,
        quantity: quantity,
      );
      if (message.isNotEmpty) {
        FlashHelper.errorBar(context, message: message);
      } else {
        FlashHelper.successBar(
          context,
          message: S.of(context).addToCartSucessfully,
        );
      }
    }

    var _canAddToCart = !item!.isEmptyProduct() &&
        item!.inStock != null &&
        item!.inStock! &&
        item!.type != 'variable' &&
        item!.type != 'appointment' &&
        item!.type != 'booking' &&
        item!.type != 'external' &&
        (item!.addOns?.isEmpty ?? true);
    var _quantity = 1;
    var _cartIcon = IconButton(
      iconSize: 18.0,
      icon: const Icon(
        Icons.add_shopping_cart,
      ),
      onPressed: () => addToCart(context, quantity: _quantity),
    );

    var priceProduct = PriceTools.getPriceProductValue(
      item,
      currency,
      onSale: true,
    );

    void onTapProduct() {
      if (item!.imageFeature == '') return;
      //Load update product detail screen for FluxBuilder
      eventBus.fire(const EventDetailSettings());
      FluxNavigate.pushNamed(
        RouteList.productDetail,
        arguments: item,
      );
    }

    /// Product Pricing
    Widget _productPricing = Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: <Widget>[
        Text(
          item!.type == 'grouped'
              ? '${S.of(context).from} ${PriceTools.getPriceProduct(item, currencyRate, currency, onSale: true)}'
              : priceProduct == '0.0'
                  ? S.of(context).loading
                  : PriceTools.getPriceProduct(item, currencyRate, currency,
                      onSale: true)!,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 15,
                color: theme.colorScheme.secondary,
              ),
        ),
        if (isSale) ...[
          const SizedBox(width: 5),
          Text(
            item!.type == 'grouped'
                ? ''
                : PriceTools.getPriceProduct(item, currencyRate, currency,
                    onSale: false)!,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  decoration: TextDecoration.lineThrough,
                ),
          ),
        ]
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: onTapProduct,
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: type == SimpleListType.backgroundColor
                ? Theme.of(context).primaryColorLight
                : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: ImageTools.image(
                    url: item!.imageFeature,
                    width: imageWidth,
                    size: kSize.medium,
                    isResize: true,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item!.name!,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      if (type != SimpleListType.priceOnTheRight)
                        _productPricing
                    ],
                  ),
                ),
                if (type == SimpleListType.priceOnTheRight)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: _productPricing,
                  ),
                if (kProductDetail.showAddToCartInSearchResult && _canAddToCart)
                  _cartIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
