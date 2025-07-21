// lib/controllers/cart_controller.dart

import 'package:get/get.dart';
import 'package:saakouk/models/product_model.dart';

class CartController extends GetxController {
  var cartList = <Product>[].obs;

  void addToCart(Product product) {
    if (!isInCart(product)) {
      cartList.add(product);
    }
  }

  bool isInCart(Product product) {
    return cartList.any((p) => p.name == product.name);
  }

  void removeFromCart(Product product) {
    cartList.removeWhere((p) => p.name == product.name);
  }
}
