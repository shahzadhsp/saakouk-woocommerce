import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saakouk/res/app_colors.dart';
import 'package:saakouk/view/profile/edit_profile_screen.dart';
import 'package:saakouk/view/signup/sign_in/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> userData = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'No user logged in';
          isLoading = false;
        });
        return;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>? ?? {};
          isLoading = false;
        });
      } else {
        // Create basic profile if document doesn't exist
        await _createInitialUserProfile(user);
        setState(() {
          userData = {
            'firstName': user.displayName?.split(' ').first ?? 'User',
            'lastName': user.displayName?.split(' ').last ?? '',
            'email': user.email ?? '',
          };
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load profile';
        isLoading = false;
      });
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> _createInitialUserProfile(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'firstName': user.displayName?.split(' ').first ?? 'User',
        'lastName': user.displayName?.split(' ').last ?? '',
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': user.emailVerified,
      });
    } catch (e) {
      debugPrint('Error creating user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Profile'),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              // Profile Avatar
              Center(
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Name
              Text(
                '${userData?['firstName'] ?? ''} ${userData?['lastName'] ?? 'Huma Safder'}',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              Text(
                userData!['email'] ?? 'admin@example.com',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 24.h),
              // Profile Menu Options
              _buildProfileTile(
                icon: Icons.edit,
                title: "Edit Profile",
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditProfileScreen(userData: userData),
                    ),
                  );

                  // Refresh profile if changes were made
                  if (result == true) {
                    _fetchUserData();
                  }
                },
              ),
              // _buildProfileTile(
              //   icon: Icons.location_on_outlined,
              //   title: "Shipping Address",
              //   onTap: () {},
              // ),
              // _buildProfileTile(
              //   icon: Icons.history,
              //   title: "Order History",
              //   onTap: () {},
              // ),
              // _buildProfileTile(
              //   icon: Icons.settings,
              //   title: "Settings",
              //   onTap: () {},
              // ),
              _buildProfileTile(
                icon: Icons.logout,
                title: "Log Out",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(userType: 'userType'),
                    ),
                  );
                },
                color: Colors.redAccent,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logoutUser() async {
    try {
      await _auth.signOut();
      // Navigate to login screen or root of your app
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: ${e.toString()}')),
      );
    }
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.black),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
