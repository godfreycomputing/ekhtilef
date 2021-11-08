import '../../entities/order_delivery_date.dart';

import 'cart_mixin.dart';

mixin OrderDeliveryMixin on CartMixin {
  OrderDeliveryDate? selectedDate;

  void setOrderDeliveryDate(OrderDeliveryDate ordd) {
    selectedDate = ordd;
  }
}
