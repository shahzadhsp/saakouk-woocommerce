import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saakouk/controllers/home_controller.dart';
import 'package:saakouk/models/product_model.dart';
import 'package:saakouk/view/signup/home/product_details/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEditRack;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEditRack,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Container(
        width: 140,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    product.imageUrl.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                        : const Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.name, overflow: TextOverflow.ellipsis),
            Text(
              '\$${product.price}',
              style: const TextStyle(color: Colors.green),
            ),
            FutureBuilder<String?>(
              future: controller.getRackByProductName(product.name),
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rack: ${snapshot.data ?? "Unknown"}'),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.blue,
                      ),
                      onPressed: onEditRack,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
