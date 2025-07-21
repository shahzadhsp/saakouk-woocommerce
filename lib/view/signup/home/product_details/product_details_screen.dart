import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saakouk/models/product_model.dart';
import 'package:saakouk/res/app_colors.dart';
import 'package:saakouk/view/favourite/favourite_screen.dart';
import 'package:saakouk/view/signup/cart/cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,

        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(product.name, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child:
                    product.imageUrl.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                        : const Center(child: Icon(Icons.image, size: 40)),
              ),
              SizedBox(height: 16.h),
              Text(
                product.name,
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6.h),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              const Text(
                'This is the product description. You can replace this with your actual content. Make sure to highlight the key features and benefits.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.h),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (!cartList.any((p) => p.name == product.name)) {
                          cartList.add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to cart")),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Already in cart")),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: AppColors.whiteColor,
                        size: 20.sp,
                      ),
                      label: Text(
                        "Add to Cart",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (!favoriteList.any((p) => p.name == product.name)) {
                          favoriteList.add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to favorites")),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoriteScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Already in favorites"),
                            ),
                          );
                        }
                      },

                      icon: Icon(
                        Icons.favorite_border,
                        color: AppColors.whiteColor,
                        size: 20.sp,
                      ),
                      label: Text(
                        "Add to Favorite",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
