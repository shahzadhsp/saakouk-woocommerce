import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saakouk/controllers/cart_controller.dart';
import 'package:saakouk/controllers/favourite_controller.dart';
import 'package:saakouk/res/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saakouk/view/signup/select_category/select_category_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  Get.put(FavoriteController()); // global instance
  Get.put(CartController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: SelectCategoryScreen(),
        );
      },
    );
  }
}
