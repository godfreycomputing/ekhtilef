import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../services/index.dart';
import '../cart/cart_model.dart';
import '../entities/order_delivery_date.dart';
import '../entities/shipping_method.dart';
import 'store_model.dart';

class VendorShippingMethodModel extends ChangeNotifier {
  final Services _service = Services();
  List<VendorShippingMethod> list = [];
  bool isLoading = true;
  String? message;

  List<OrderDeliveryDate>? _deliveryDates;
  List<OrderDeliveryDate>? get deliveryDates => _deliveryDates;

  Future<void> getShippingMethods(
      {CartModel? cartModel, required List<Store?> stores}) async {
    try {
      isLoading = true;
      list = [];
      notifyListeners();
      for (var i = 0; i < stores.length; i++) {
        final store = stores[i];
        var items = await _service.api
            .getShippingMethods(cartModel: cartModel, store: store)!;
        if (items.isNotEmpty) {
          list.add(VendorShippingMethod(store, items));
        }
      }
      if (kAdvanceConfig['EnableDeliveryDateOnCheckout']) {
        _deliveryDates = await getDelivery();
      }
      isLoading = false;
      message = null;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      message = '⚠️ ' + err.toString();
      notifyListeners();
    }
  }

  Future<List<OrderDeliveryDate>> getDelivery() async {
    return await _service.api.getListDeliveryDates();
  }
}

class VendorShippingMethod {
  Store? store;
  List<ShippingMethod> shippingMethods = [];

  VendorShippingMethod(this.store, this.shippingMethods);
}
