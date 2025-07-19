import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saakouk/res/app_colors.dart';
import 'package:saakouk/view/bottom_navigationbar.dart/bottom_navigationbar.dart';
import 'package:saakouk/view/signup/common_widgets.dart/text_form_field.dart';
import 'package:saakouk/view/signup/sign_in/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Future<void> _signUpWithEmailAndPassword() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // 1. Create user with email/password
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(
  //           email: emailController.text.trim(),
  //           password: passwordController.text.trim(),
  //         );

  //     // 2. Update user display name in Firebase Auth
  //     await userCredential.user?.updateDisplayName(
  //       '${nameController.text.trim()} ${lastNameController.text.trim()}',
  //     );

  //     // 3. Send email verification
  //     await userCredential.user?.sendEmailVerification();

  //     // 4. Store additional user data in Firestore
  //     final String id = DateTime.now().millisecondsSinceEpoch.toString();

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user?.uid)
  //         .set({
  //           'uid': userCredential.user?.uid,
  //           'firstName': nameController.text.trim(),
  //           'lastName': lastNameController.text.trim(),
  //           'email': emailController.text.trim(),
  //           'password':
  //               passwordController.text
  //                   .trim(), // Note: Storing passwords is not recommended
  //           'confirmPassword':
  //               confirmPasswordController.text.trim(), // Not typically stored
  //           'createdAt': FieldValue.serverTimestamp(),
  //           'emailVerified': false,
  //           'profileCompleted': false,
  //           // Add any additional fields you need
  //         });

  //     // 5. Navigate to home screen after successful sign up
  //     if (mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => MainNavigation()),
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage = 'An error occurred. Please try again.';

  //     if (e.code == 'weak-password') {
  //       errorMessage = 'The password provided is too weak.';
  //     } else if (e.code == 'email-already-in-use') {
  //       errorMessage = 'The account already exists for that email.';
  //     } else if (e.code == 'invalid-email') {
  //       errorMessage = 'The email address is not valid.';
  //     }

  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(errorMessage)));
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('An unexpected error occurred.')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }
  Future<void> _signUpWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Create user with email/password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // 2. Update user display name in Firebase Auth
      await userCredential.user?.updateDisplayName(
        '${nameController.text.trim()} ${lastNameController.text.trim()}',
      );

      // 3. Send email verification
      await userCredential.user?.sendEmailVerification();

      // 4. Generate custom ID
      final String customId = DateTime.now().millisecondsSinceEpoch.toString();

      // 5. Store additional user data in Firestore with custom ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(customId) // Using custom ID instead of user UID
          .set({
            'firebaseUid':
                userCredential.user?.uid, // Still store Firebase UID as a field
            'customId': customId, // Store the custom ID as well
            'firstName': nameController.text.trim(),
            'lastName': lastNameController.text.trim(),
            'email': emailController.text.trim(),
            // Remove password storage (security best practice)
            'createdAt': FieldValue.serverTimestamp(),
            'emailVerified': false,
            'profileCompleted': false,
            // Add any additional fields you need
          });

      // 6. Navigate to home screen after successful sign up
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigation(userType: '')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return;

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     UserCredential userCredential = await _auth.signInWithCredential(
  //       credential,
  //     );

  //     // Navigate to home screen after successful sign in
  //     if (mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => MainNavigation()),
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Google sign in failed: ${e.message}')),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('An error occurred during Google sign in')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: double.maxFinite,
        color: AppColors.blackColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Full screen black background
              Container(
                height: 130.h,
                width: double.maxFinite,
                color: AppColors.blackColor,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 24.sp,
                          color: AppColors.whiteColor,
                        ),
                        Text(
                          'Sign Up',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp,
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              // White container on top
              Form(
                key: _formKey,
                child: Container(
                  height: screenHeight - 140, // Fix applied here
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          CustomText(text: 'First Name'),
                          SizedBox(height: 6.h),
                          CustomTextFormField(
                            labelText: 'First Name',
                            hintText: 'Enter your first name',
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            },
                            prefixIcon: Icon(Icons.person_outline),
                            fillColor: Colors.white,
                          ),
                          SizedBox(height: 10.h),
                          CustomText(text: 'Last Name'),
                          SizedBox(height: 6.h),
                          CustomTextFormField(
                            labelText: 'Last Name',
                            hintText: 'Enter your Last name',
                            controller: lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                            prefixIcon: Icon(Icons.person_outline),
                            // suffixIcon: Icon(
                            //   Icons.check_circle_outline,
                            //   color: Colors.green,
                            // ),
                            fillColor: Colors.white, // Optional
                          ),

                          SizedBox(height: 10.h),
                          CustomText(text: 'Email'),
                          SizedBox(height: 6.h),

                          /// Email
                          CustomTextFormField(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            controller: emailController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                            prefixIcon: Icon(Icons.email_outlined),
                          ),

                          SizedBox(height: 10.h),
                          CustomText(text: 'Password'),
                          SizedBox(height: 6.h),
                          CustomTextFormField(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            onToggleObscureText: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            prefixIcon: const Icon(Icons.lock_outline),
                            fillColor: Colors.white,
                          ),
                          SizedBox(height: 10.h),
                          CustomText(text: 'Confirm Password'),
                          SizedBox(height: 6.h),
                          CustomTextFormField(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            controller: confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            onToggleObscureText: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            prefixIcon: const Icon(Icons.lock_outline),
                            fillColor: Colors.white,
                          ),
                          // adminsaakouk@gmail.com
                          //12345678
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : _signUpWithEmailAndPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child:
                                  _isLoading
                                      ? CircularProgressIndicator(
                                        strokeWidth: 4.w,
                                        color: AppColors.blackColor,
                                      )
                                      : Text(
                                        'Sign Up',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 2.h,
                                  width: 100,
                                  color: Colors.blueGrey.shade300,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text('Or Sign up with'),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Container(
                                  height: 1.h,
                                  width: 100,
                                  color: Colors.blueGrey.shade300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            MainNavigation(userType: ''),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.g_mobiledata,
                                    size: 24.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                  Text(
                                    'Sign Up with Google',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 6.w),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              SignInScreen(userType: ''),
                                    ),
                                  );
                                  log('click on this ');
                                },
                                child: Text(
                                  "Log In",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;

  const CustomText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
    );
  }
}
