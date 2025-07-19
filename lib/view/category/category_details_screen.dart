// category_products_screen.dart

import 'package:flutter/material.dart';
import 'package:saakouk/data/services/woo_service_store.dart';
import 'package:saakouk/models/product_model.dart';
import 'package:saakouk/res/app_colors.dart';
import 'package:saakouk/view/signup/home/product_details/product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> _products = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // Future<void> loadProducts() async {
  //   final data = await WooServiceStore.fetchProductsByCategory(
  //     widget.categoryId,
  //   );
  //   setState(() {
  //     _products = data.map<Product>((json) => Product.fromJson(json)).toList();
  //     _isLoading = false;
  //   });
  // }
  Future<void> loadProducts() async {
    try {
      final data = await WooServiceStore.fetchProductsByCategory(
        widget.categoryId,
      );
      if (data is List) {
        setState(() {
          _products =
              data.map<Product>((json) => Product.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Invalid response: not a list");
      }
    } catch (e) {
      print("❌ Error loading category products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.categoryName),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _products.isEmpty
              ? const Center(child: Text('No products found'))
              : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final image = product.imageUrl;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                image != null
                                    ? Image.network(
                                      image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    ),
                          ),
                          const SizedBox(width: 16),

                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? 'No name',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Rs. ${product.price ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
