/// lib/features/order/bindings/order_binding.dart

import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class OrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}