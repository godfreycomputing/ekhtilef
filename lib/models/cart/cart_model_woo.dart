import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../services/dependency_injection.dart';
import '../../services/index.dart';
import '../entities/index.dart' show Product, ProductVariation;
import 'cart_base.dart';
import 'mixin/index.dart';

class CartModelWoo
    with
        ChangeNotifier,
        CartMixin,
        MagentoMixin,
        AddressMixin,
        LocalMixin,
        CurrencyMixin,
        CouponMixin,
        ShopifyMixin,
        OpencartMixin,
        VendorMixin,
        OrderDeliveryMixin
    implements CartModel {
  static final CartModelWoo _instance = CartModelWoo._internal();

  factory CartModelWoo() => _instance;

  CartModelWoo._internal();

  @override
  Future<void> initData() async {
    await getShippingAddress();
    await getCartInLocal();
    await getCurrency();
  }

  @override
  double getTotal() {
    var subtotal = getSubTotal() ?? 1.0;

    if (couponObj != null) {
      subtotal -= getCouponCost();
    }

    if (subtotal < 0.0) {
      subtotal = 0.0;
    }

    if (kPaymentConfig['EnableShipping']) {
      subtotal += getShippingCost()!;
    }

    if (taxes.isNotEmpty) {
      subtotal += taxesTotal;
    }

    subtotal -= rewardTotal;

    return subtotal;
  }

  @override
  double getProductPrice(id) {
    var productId = Product.cleanProductID(id);
    if (item[productId]!.type == 'subscription') {
      final signUpFee = item[productId]!.metaData.firstWhere(
          (element) => element['key'] == '_subscription_sign_up_fee',
          orElse: () => {})['value'];
      if ((signUpFee?.isNotEmpty ?? false) && productsInCart[id] != null) {
        return double.parse(signUpFee!) * productsInCart[id]!;
      }
      return 0.0;
    }

    return super.getProductPrice(id);
  }

  @override
  bool isEnabledShipping() {
    var id = productsInCart.keys.firstWhereOrNull((id) {
      var productId = Product.cleanProductID(id);
      return item[productId]!.type == 'subscription' ||
          item[productId]!.type == 'variable-subscription';
    });
    if (id != null) {
      return false;
    }
    return super.isEnabledShipping();
  }

  @override
  double getItemTotal(
      {ProductVariation? productVariation,
      Product? product,
      int quantity = 1}) {
    var subtotal = double.parse(product!.price!) * quantity;
    if (productVariation != null) {
      subtotal = double.parse(productVariation.price!) * quantity;
    } else {
      subtotal = double.parse(product.price!) * quantity;
    }
    if (product.selectedOptions?.isNotEmpty ?? false) {
      subtotal += product.getProductOptionsPrice(quantity);
    }
    return subtotal;
  }

  @override
  String updateQuantity(Product product, String key, int quantity, {context}) {
    final isClosed =
        (product.store != null && product.store!.storeHour != null) &&
            (product.store!.storeHour!.isDisablePurchase! &&
                !product.store!.storeHour!.isOpen());
    if (isClosed) {
      return S.of(context).storeClosed;
    }
    var message = '';
    var total = quantity;
    ProductVariation? variation;

    if (key.contains('-')) {
      variation = getProductVariationById(key);
    }

    var stockQuantity =
        variation == null ? product.stockQuantity : variation.stockQuantity;

    if (!product.manageStock) {
      productsInCart[key] = total;
    } else if (total <= stockQuantity!) {
      if (product.minQuantity == null && product.maxQuantity == null) {
        productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity == null) {
        total < product.minQuantity!
            ? message =
                '${S.of(context).minimumQuantityIs} ${product.minQuantity}'
            : productsInCart[key] = total;
      } else if (product.minQuantity == null && product.maxQuantity != null) {
        total > product.maxQuantity!
            ? message =
                '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}'
            : productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity != null) {
        if (total >= product.minQuantity! && total <= product.maxQuantity!) {
          productsInCart[key] = total;
        } else {
          if (total < product.minQuantity!) {
            message =
                '${S.of(context).minimumQuantityIs} ${product.minQuantity}';
          }
          if (total > product.maxQuantity!) {
            message =
                '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}';
          }
        }
      }
    } else {
      message =
          '${S.of(context).currentlyWeOnlyHave} $stockQuantity ${S.of(context).ofThisProduct}';
    }
    if (message.isEmpty) {
      updateQuantityCartLocal(key: key, quantity: quantity);
      notifyListeners();
    }

    updateDiscount(onFinish: notifyListeners);

    Services().widget.syncCartToWebsite(this);

    return message;
  }

// Removes an item from the cart.
  @override
  void removeItemFromCart(String key) {
    if (productsInCart.containsKey(key)) {
      productsInCart.remove(key);
      productVariationInCart.remove(key);
      productAddonsOptionsInCart.remove(key);

      /// In case there are multiple item with same product ID.
      /// Example: [1234+Small, 1234+Medium]
      var shouldRemove = true;
      var productId = Product.cleanProductID(key);
      for (var inCartKey in productsInCart.keys) {
        var productIdInCart = Product.cleanProductID(inCartKey);
        if (productIdInCart == productId) {
          shouldRemove = false;
          break;
        }
      }
      if (shouldRemove) {
        item.remove(productId);
      }

      removeProductLocal(key);
    }

    updateDiscount(onFinish: notifyListeners);
    notifyListeners();

    Services().widget.syncCartToWebsite(this);
  }

// Removes everything from the cart.
  @override
  void clearCart() {
    clearCartLocal();
    productsInCart.clear();
    item.clear();
    productVariationInCart.clear();
    productAddonsOptionsInCart.clear();
    shippingMethod = null;
    paymentMethod = null;
    resetCoupon();
    notes = null;
    rewardTotal = 0;
    notifyListeners();

    Services().widget.syncCartToWebsite(this);
  }

  @override
  void setOrderNotes(String note) {
    notes = note;
    notifyListeners();
  }

  @override
  String addProductToCart({
    context,
    Product? product,
    int? quantity = 1,
    ProductVariation? variation,
    Function? notify,
    isSaveLocal = true,
    Map<String, dynamic>? options,
  }) {
    if (product != null && product.store != null) {
      final isClosed = (product.store!.storeHour != null) &&
          (product.store!.storeHour!.isDisablePurchase! &&
              !product.store!.storeHour!.isOpen());
      if (isClosed) {
        return S.of(context).storeClosed;
      }
    }

    var message = '';

    var key = product!.id.toString();
    if (variation != null) {
      if (variation.id != null) {
        key += '-${variation.id}';
      }
      for (var option in options!.keys) {
        key += '-' + option + options[option];
      }
    } else if (product.bookingInfo != null) {
      key += '-${product.bookingInfo!.timeStart.toString()}';
    }

    if (product.stockQuantity != null) {
      if (quantity! > product.stockQuantity!) {
        return '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}';
      }
    }

    if (kCartDetail['maxAllowQuantity'] != null) {
      /// First time adding a product, the product will be null so the quantity should be -1 for the condition to be valid.
      if (product.stockQuantity != null) {
        if (quantity! > product.stockQuantity!) {
          return '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}';
        }
      } else {
        var isExceeded = ((productsInCart[key] ?? -1) + quantity!) >=
            kCartDetail['maxAllowQuantity'];

        if (isExceeded) {
          message =
              '${S.of(context).youCanOnlyPurchase} ${kCartDetail['maxAllowQuantity']} ${S.of(context).forThisProduct}';
          return message;
        }
      }
    }

    try {
      /// Product variations.
      if (product.type == 'variable') {
        /// Loading attributes & variants.
        if (variation == null && (options?.isEmpty ?? true)) {
          message = S.of(context).loading;
          return message;
        }

        /// Not selected all attributes.
        if (options!.isNotEmpty && options.values.contains(null)) {
          message = S.of(context).pleaseSelectAllAttributes;
          return message;
        }
      }

      /// Product addons.
      if (product.addOns?.isNotEmpty ?? false) {
        for (var addOns in product.addOns!) {
          if (addOns.required ?? false) {
            final requiredOptions =
                addOns.options!.map((e) => e.label).toList();
            final check = product.selectedOptions?.firstWhereOrNull(
                (option) => requiredOptions.contains(option.label));
            if (check == null) {
              message = S.of(context).pleaseSelectRequiredOptions;
              return message;
            }
          }
        }
      }

      if (product.selectedOptions?.isNotEmpty ?? false) {
        key += '+${product.selectedOptions!.map((e) => e.label).join('+')}';
      }

      //Check product's quantity before adding to cart
      var total = !productsInCart.containsKey(key)
          ? quantity
          : productsInCart[key]! + quantity!;
      var stockQuantity =
          variation == null ? product.stockQuantity : variation.stockQuantity;

      if (!product.manageStock || product.backOrdered) {
        productsInCart[key] = total;
      } else if (total! <= stockQuantity!) {
        if (product.minQuantity == null && product.maxQuantity == null) {
          productsInCart[key] = total;
        } else if (product.minQuantity != null && product.maxQuantity == null) {
          total < product.minQuantity!
              ? message =
                  '${S.of(context).minimumQuantityIs} ${product.minQuantity}'
              : productsInCart[key] = total;
        } else if (product.minQuantity == null && product.maxQuantity != null) {
          total > product.maxQuantity!
              ? message =
                  '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}'
              : productsInCart[key] = total;
        } else if (product.minQuantity != null && product.maxQuantity != null) {
          if (total >= product.minQuantity! && total <= product.maxQuantity!) {
            productsInCart[key] = total;
          } else {
            if (total < product.minQuantity!) {
              message =
                  '${S.of(context).minimumQuantityIs} ${product.minQuantity}';
            }
            if (total > product.maxQuantity!) {
              message =
                  '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}';
            }
          }
        }
      } else {
        message =
            '${S.of(context).currentlyWeOnlyHave} $stockQuantity ${S.of(context).ofThisProduct}';
      }

      if (message.isEmpty) {
        item[product.id] = product;
        productVariationInCart[key] = variation;
        productsMetaDataInCart[key] = options;
        productAddonsOptionsInCart[key] = product.selectedOptions;

        if (isSaveLocal) {
          saveCartToLocal(
              product: product,
              quantity: quantity,
              variation: variation,
              options: options);
        }
      }

      updateDiscount(onFinish: notifyListeners);
      notifyListeners();

      Services().widget.syncCartToWebsite(this);
    } catch (err) {
      if (err is ArgumentError) {
        return S.of(context).pleaseSelectAllAttributes;
      }
    }
    return message;
  }

  @override
  void setRewardTotal(double total) {
    rewardTotal = total;
    notifyListeners();
  }

  double getShippingVendorCost() {
    var sum = 0.0;

    for (var element in selectedShippingMethods) {
      sum += element.shippingMethods[0].cost ?? 0.0;
    }
    return sum;
  }

  @override
  double? getShippingCost() {
    var isMultiVendor = kFluxStoreMV.contains(serverConfig['type']);
    return isMultiVendor ? getShippingVendorCost() : super.getShippingCost();
  }

  @override
  void loadSavedCoupon() {
    final _sharedPrefs = injector<SharedPreferences>();

    final _savedCoupon = _sharedPrefs.getString('saved_coupon');
    savedCoupon = _savedCoupon;
    notifyListeners();
  }
}
