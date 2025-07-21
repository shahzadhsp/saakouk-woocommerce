import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:saakouk/data/services/woo_service_cafe.dart';
import 'package:saakouk/data/services/woo_service_store.dart';
import 'package:saakouk/models/product_model.dart';

class HomeController extends GetxController {
  final String userType;
  HomeController({required this.userType});

  var topSelling = <Product>[].obs;
  var latestProducts = <Product>[].obs;
  var categories = <Product>[].obs;
  var isLoading = true.obs;
  var loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (userType == 'store') {
      fetchStoreProducts();
      loadStoreCategories();
    } else if (userType == 'cafe') {
      fetchCafeProducts();
      loadCafeCategories();
    }
  }

  Future<void> loadStoreCategories() async {
    final data = await WooServiceStore.fetchCategories();
    log("✅ Store Categories Length: ${data.length}");
    categories.value = data;
    isLoading.value = false;
  }

  Future<void> loadCafeCategories() async {
    final data = await CafeWooService.fetchCategories();
    log("✅ Cafe Categories Length: ${data.length}");
    categories.value = data;
    isLoading.value = false;
  }

  void fetchStoreProducts() async {
    var data = await WooServiceStore.fetchProducts();

    List<Product> allProducts =
        data.map((item) {
          final name = item['name'];
          final price = double.tryParse(item['price'].toString()) ?? 0.0;
          final image =
              item['images'].isNotEmpty ? item['images'][0]['src'] : '';
          saveProductToFirebase(name, price);
          return Product(id: 0, name: name, price: price, imageUrl: image);
        }).toList();

    topSelling.value = allProducts.take(6).toList();
    latestProducts.value = allProducts.skip(6).take(10).toList();
    loading.value = false;
  }

  void fetchCafeProducts() async {
    var data = await CafeWooService.fetchProducts();

    List<Product> allProducts =
        data.map((item) {
          final name = item['name'];
          final price = double.tryParse(item['price'].toString()) ?? 0.0;
          final image =
              item['images'].isNotEmpty ? item['images'][0]['src'] : '';
          saveProductToFirebase(name, price);
          return Product(id: 0, name: name, price: price, imageUrl: image);
        }).toList();

    topSelling.value = allProducts.take(6).toList();
    latestProducts.value = allProducts.skip(6).take(10).toList();
    loading.value = false;
  }

  String getRack(double price) {
    if (price >= 700 && price <= 800) return '1';
    if (price > 600 && price < 700) return '2';
    if (price > 500 && price <= 600) return '3';
    if (price > 400 && price <= 500) return '4';
    if (price > 300 && price <= 400) return '5';
    return '6';
  }

  Future<void> saveProductToFirebase(String name, double price) async {
    final rack = getRack(price);
    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'rack': rack,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('✅ Product saved: $name - $price - $rack');
  }

  Future<String?> getRackByProductName(String name) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .where('name', isEqualTo: name)
            .limit(1)
            .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['rack'] as String?;
    }
    return null;
  }

  Future<void> updateRackByProductName(
    String productName,
    String newRack,
  ) async {
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('products')
              .where('name', isEqualTo: productName)
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        await FirebaseFirestore.instance
            .collection('products')
            .doc(docId)
            .update({'rack': newRack});

        // Corrected refresh logic
        if (userType == 'store') {
          fetchStoreProducts();
        } else if (userType == 'cafe') {
          fetchCafeProducts();
        }
        // or update the specific product locally if using RxList
      } else {
        Get.snackbar("Error", "Product not found in Firestore");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update rack: $e");
    }
  }
}
