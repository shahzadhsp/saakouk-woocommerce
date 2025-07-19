import 'package:saakouk/models/product_model.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

// cafe data
class CafeWooService {
  static final WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
    url: "https://saakoukcafe.com",
    consumerKey: "ck_3eb46a3dccd426c2112902d33e8f6e8fc6943c33",
    consumerSecret: "cs_293593a5ae8fb057ce210da1696cf2c475149480",
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
