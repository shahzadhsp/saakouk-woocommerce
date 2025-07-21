import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saakouk/controllers/cart_controller.dart';
import 'package:saakouk/models/product_model.dart';
import 'package:saakouk/res/app_colors.dart';

class CheckoutReviewScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CheckoutReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = cartController.cartList;

    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text("Review Order"),
        centerTitle: true,
        backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
        iconTheme: IconThemeData(
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                Product product = cartItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      if (!Get.isDarkMode)
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            product.imageUrl.isNotEmpty
                                ? Image.network(
                                  product.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: 60,
                                  height: 60,
                                  color:
                                      Get.isDarkMode
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade300,
                                  child: const Icon(Icons.image, size: 30),
                                ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${product.quantity} x \$${product.price.toStringAsFixed(2)} = \$${(product.quantity * product.price).toStringAsFixed(2)}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${cartItems.fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // You can place your order save logic here
                      Get.snackbar(
                        "Order Placed",
                        "Your order has been confirmed!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Confirm Order",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
