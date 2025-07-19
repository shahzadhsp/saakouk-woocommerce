import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saakouk/res/app_colors.dart';
import 'package:saakouk/view/signup/sign_in/sign_in_screen.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});
  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // body: Stack(
      //   children: [
      //     // ✅ Foreground UI
      //     SafeArea(
      //       child: Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 24.w),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             SizedBox(height: 60.h),
      //             Text(
      //               "Select Your Store",
      //               style: Theme.of(context).textTheme.headlineSmall!.copyWith(
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.black,
      //               ),
      //               textAlign: TextAlign.center,
      //             ),
      //             SizedBox(height: 40.h),
      //             Padding(
      //               padding: EdgeInsets.only(left: 20.w),
      //               child: Align(
      //                 alignment: Alignment.center,
      //                 child: Opacity(
      //                   opacity: 0.6,
      //                   child: Image.asset(
      //                     'assets/icon/saakouk.png',
      //                     width: 300.w,
      //                     fit: BoxFit.contain,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(height: 40.h),

      //             /// Saakouk button Store
      //             SizedBox(
      //               width: double.infinity,
      //               child: ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder:
      //                           (context) => SignInScreen(userType: 'store'),
      //                     ),
      //                   );
      //                 },
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.black,
      //                   foregroundColor: Colors.white,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(6),
      //                   ),
      //                   padding: EdgeInsets.symmetric(vertical: 16.h),
      //                 ),
      //                 child: Text(
      //                   'Continue as a Saakouk store',
      //                   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
      //                     color: AppColors.whiteColor,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(height: 20.h),

      //             /// Saakouk Cafe button Cafe
      //             SizedBox(
      //               width: double.infinity,
      //               child: ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder:
      //                           (context) => SignInScreen(userType: 'cafe'),
      //                     ),
      //                   );
      //                 },
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.black,
      //                   foregroundColor: Colors.white,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(6),
      //                   ),
      //                   padding: EdgeInsets.symmetric(vertical: 16.h),
      //                 ),
      //                 child: Text(
      //                   'Continue as a Saakouk cafe',
      //                   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
      //                     color: AppColors.whiteColor,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          // 🔳 Background Image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1586684555402-092f68c7d491?q=80&w=435&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // black & white themed background
              fit: BoxFit.cover,
            ),
          ),

          // 🔳 Semi-transparent overlay for better readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // 🔳 Foreground UI
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),
                  Text(
                    "Select Your Store",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.6,
                        child: Image.asset(
                          'assets/icon/saakouk.png',
                          width: 300.w,
                          fit: BoxFit.contain,
                          color: Colors.white.withOpacity(
                            0.5,
                          ), // Apply white color to the logo
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // 🔘 Store Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SignInScreen(userType: 'store'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        'Continue as a Saakouk store',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // 🔘 Cafe Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SignInScreen(userType: 'cafe'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        'Continue as a Saakouk cafe',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
