// store data
import 'package:saakouk/models/product_model.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class WooServiceStore {
  static final WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
    url: "https://saakouk.com", // 🔁 New store URL
    consumerKey: "ck_b6a20d64c6cc44e16697e7ec1ca948bd6d25a5d5",
    consumerSecret: "cs_87376efe085f357e319e639b64433b5140ac2e0c",
  );

  static Future<List> fetchProducts() async {
    try {
      var response = await wooCommerceAPI.getAsync("products");
      return response;
    } catch (e) {
      print("❌ Error fetching products: $e");
      return [];
    }
  }

  // fetch categories
  static Future<List<Product>> fetchCategories() async {
    try {
      var response = await wooCommerceAPI.getAsync("products/categories");
      print("✅ Categories fetched: $response");

      return List<Product>.from(response.map((cat) => Product.fromJson(cat)));
    } catch (e) {
      print("❌ Error fetching categories: $e");
      return [];
    }
  }

  // get single item
  static Future<List> fetchProductsByCategory(int categoryId) async {
    try {
      var response = await wooCommerceAPI.getAsync(
        "products?category=$categoryId",
      );
      return response;
    } catch (e) {
      print("❌ Error fetching category products: $e");
      return [];
    }
  }
}
