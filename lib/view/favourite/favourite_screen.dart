import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saakouk/controllers/favourite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
  final FavoriteController favController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Favorites"), centerTitle: true),
      body: Obx(() {
        if (favController.favoriteList.isEmpty) {
          return const Center(child: Text("No favorite items"));
        }
        return ListView.builder(
          itemCount: favController.favoriteList.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final product = favController.favoriteList[index];
            return Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      favController.toggleFavorite(product);
                    },
                    icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
