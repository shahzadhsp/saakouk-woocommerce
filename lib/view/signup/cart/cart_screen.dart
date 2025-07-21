import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saakouk/controllers/cart_controller.dart';
import 'package:saakouk/models/product_model.dart';
import 'package:saakouk/res/app_colors.dart';
import 'package:saakouk/view/checkout/checkout_review_screen.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart"), centerTitle: true),
      body: Obx(() {
        final cartList = cartController.cartList;

        if (cartList.isEmpty) {
          return Center(
            child: Text(
              "Cart is empty",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartList.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  Product product = cartList[index];
                  return Container(
                    height: 120.h,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Image/Icon container
                        Container(
                          width: 100,
                          height: double.infinity,
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
                                  : const Center(
                                    child: Icon(Icons.image, size: 40),
                                  ),
                        ),
                        const SizedBox(width: 12),
                        // Product info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                '\$${(product.price * product.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (product.quantity > 1) {
                                        product.quantity--;
                                        cartController.cartList.refresh();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      minimumSize: const Size(36, 36),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${product.quantity}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      product.quantity++;
                                      cartController.cartList.refresh();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      minimumSize: const Size(36, 36),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            cartController.removeFromCart(product);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Checkout Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Divider(),
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
                        '\$${cartController.cartList.fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => CheckoutReviewScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Checkout",
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
        );
      }),
    );
  }
}
