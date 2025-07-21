// lib/controllers/favorite_controller.dart

import 'package:get/get.dart';
import 'package:saakouk/models/product_model.dart';

class FavoriteController extends GetxController {
  var favoriteList = <Product>[].obs;

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      favoriteList.removeWhere((p) => p.name == product.name);
    } else {
      favoriteList.add(product);
    }
  }

  bool isFavorite(Product product) {
    return favoriteList.any((p) => p.name == product.name);
  }
}
