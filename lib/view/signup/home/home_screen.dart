import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saakouk/data/services/woo_service_cafe.dart';
import 'package:saakouk/data/services/woo_service_store.dart';
import 'package:saakouk/models/product_model.dart';
import 'package:saakouk/res/app_colors.dart';
import 'package:saakouk/view/category/category_details_screen.dart';
import 'package:saakouk/view/favourite/favourite_screen.dart';
import 'package:saakouk/view/profile/profile_screen.dart';
import 'package:saakouk/view/signup/cart/cart_screen.dart';
import 'package:saakouk/view/signup/home/product_details/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userType;
  const HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> topSelling = [];
  List<Product> latestProducts = [];
  List<Product> _categories = [];
  bool _isLoading = true;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    print("User Type is: ${widget.userType}");

    if (widget.userType == 'store') {
      fetchStoreProducts();
      loadStoreCategories();
    } else if (widget.userType == 'cafe') {
      fetchCafeProducts();
      loadCafeCategories();
    }
  }

  // load store categories
  Future<void> loadStoreCategories() async {
    final data = await WooServiceStore.fetchCategories();
    log("✅ Parsed Categories Length: ${data.length}"); // ADD THIS
    setState(() {
      _categories = data;
      _isLoading = false;
    });
  }

  // load cafe categories
  Future<void> loadCafeCategories() async {
    final data = await CafeWooService.fetchCategories();
    log("✅ Parsed Categories Length: ${data.length}"); // ADD THIS
    setState(() {
      _categories = data;
      _isLoading = false;
    });
  }

  void fetchCafeProducts() async {
    var data = await CafeWooService.fetchProducts();

    List<Product> allProducts =
        data.map((item) {
          final name = item['name'];
          final price = double.tryParse(item['price'].toString()) ?? 0.0;
          final image =
              item['images'].isNotEmpty ? item['images'][0]['src'] : '';
          // Save to Firebase
          saveProductToFirebase(name, price);
          return Product(id: 0, name: name, price: price, imageUrl: image);
        }).toList();
    setState(() {
      topSelling = allProducts.take(6).toList();
      latestProducts = allProducts.skip(6).take(10).toList();
      loading = false;
    });
  }

  void fetchStoreProducts() async {
    var data = await WooServiceStore.fetchProducts();

    List<Product> allProducts =
        data.map((item) {
          final name = item['name'];
          final price = double.tryParse(item['price'].toString()) ?? 0.0;
          final image =
              item['images'].isNotEmpty ? item['images'][0]['src'] : '';

          // Save to Firebase
          saveProductToFirebase(name, price);

          return Product(id: 0, name: name, price: price, imageUrl: image);
        }).toList();

    setState(() {
      topSelling = allProducts.take(6).toList();
      latestProducts = allProducts.skip(6).take(10).toList();
      loading = false;
    });
  }

  // string rack
  String getRack(double price) {
    if (price >= 700 && price <= 800) return '1';
    if (price > 600 && price < 700) return '2';
    if (price > 500 && price <= 600) return '3';
    if (price > 400 && price <= 500) return '4';
    if (price > 300 && price <= 400) return '5';
    return '6'; // 300 or below
  }

  // save product to firestore

  Future<void> saveProductToFirebase(String name, double price) async {
    final rack = getRack(price);

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'rack': rack,
      'timestamp': FieldValue.serverTimestamp(), // optional
    });

    print('✅ Product saved: $name - $price - $rack');
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.grey.shade200,
      splashColor: Colors.grey.shade100,
    );
  }

  // get rack
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

  // update rack by product name
  Future<void> updateRackByProductName(String name, String newRack) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .where('name', isEqualTo: name)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(snapshot.docs.first.id)
          .update({'rack': newRack});
    }
  }

  // show rack update dialog
  void showRackUpdateDialog(BuildContext context, String productName) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Rack',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new rack value',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          actions: [
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () => Navigator.pop(context),
            //         child: const Text('Cancel'),
            //       ),
            //     ),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () async {
            //           final newRack = controller.text.trim();
            //           if (newRack.isNotEmpty) {
            //             await updateRackByProductName(productName, newRack);
            //             Navigator.pop(context);
            //             setState(() {}); // Refresh UI
            //           }
            //         },
            //         child: const Text('Update'),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newRack = controller.text.trim();
                      if (newRack.isNotEmpty) {
                        await updateRackByProductName(productName, newRack);
                        Navigator.pop(context);
                        setState(() {}); // Refresh UI
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.black87),
                child: Text(
                  'Saakouk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildDrawerTile(
                icon: Icons.home_outlined,
                title: 'Home',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildDrawerTile(
                icon: Icons.shopping_cart_outlined,
                title: 'Cart',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              _buildDrawerTile(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
              _buildDrawerTile(
                icon: Icons.favorite_border,
                title: 'Favourite',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoriteScreen()),
                  );
                },
              ),
              _buildDrawerTile(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        // automaticallyImplyLeading: false,
        title: Text(
          'Welcome ${widget.userType == "store" ? "Store Owner" : "Cafe Owner"}',
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          loading
              ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: AppColors.blackColor,
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Categories",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => CategoryProductsScreen(
                                                categoryId: category.id,
                                                categoryName: category.name,
                                              ),
                                        ),
                                      );
                                    },
                                    child:
                                        category.imageUrl.isNotEmpty
                                            ? ClipOval(
                                              child: Image.network(
                                                color:
                                                    Colors.deepPurple.shade100,
                                                category.imageUrl,
                                                fit: BoxFit.cover,
                                                width: 60,
                                                height: 60,
                                              ),
                                            )
                                            : CircleAvatar(
                                              backgroundColor: Colors.grey
                                                  .withValues(alpha: 0.2),
                                              radius: 30,
                                              child: Icon(
                                                Icons.image,
                                                size: 30,
                                              ),
                                            ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      category.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Top Selling Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Top Selling",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: topSelling.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            final product = topSelling[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ProductDetailsScreen(
                                          product: product,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child:
                                            product.imageUrl.isNotEmpty
                                                ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    product.imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  ),
                                                )
                                                : const Center(
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 40,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              topSelling[index].name.length > 10
                                                  ? '${topSelling[index].name.substring(0, 10)}...'
                                                  : topSelling[index].name,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              topSelling[index].price
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder<String?>(
                                                  future: getRackByProductName(
                                                    topSelling[index].name,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    final rack =
                                                        snapshot.data ??
                                                        'Unknown Rack';
                                                    return Text(
                                                      '$rack',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                GestureDetector(
                                                  onTap:
                                                      () =>
                                                          showRackUpdateDialog(
                                                            context,
                                                            topSelling[index]
                                                                .name,
                                                          ),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.favorite_border),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Latest Products Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Latest Products",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topSelling.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            final product = topSelling[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ProductDetailsScreen(
                                          product: product,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child:
                                            product.imageUrl.isNotEmpty
                                                ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    product.imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  ),
                                                )
                                                : const Center(
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 40,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              topSelling[index].name.length > 10
                                                  ? '${topSelling[index].name.substring(0, 10)}...'
                                                  : topSelling[index].name,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                            Text(
                                              topSelling[index].price
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                        Icon(Icons.favorite_border),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,

                                      children: [
                                        FutureBuilder<String?>(
                                          future: getRackByProductName(
                                            topSelling[index].name,
                                          ),
                                          builder: (context, snapshot) {
                                            final rack =
                                                snapshot.data ?? 'Unknown Rack';
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '$rack',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap:
                                                      () =>
                                                          showRackUpdateDialog(
                                                            context,
                                                            topSelling[index]
                                                                .name,
                                                          ),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
    );
  }
}
