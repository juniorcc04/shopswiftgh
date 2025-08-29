import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adminpanelapp/screens/profile/widget/profileoptions.dart';
import 'package:adminpanelapp/screens/profile/edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? "Guest User",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Welcome to ShopSwift',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Profile Options
            profileOptions(
              'Edit Profile',
              Icon(Icons.account_circle_outlined, color: Colors.blue[800], size: 26),
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
                if (updated == true) {
                  (context as Element).markNeedsBuild();
                }
              },
            ),
            const Divider(color: Colors.grey, thickness: 1),
            profileOptions(
              'My Orders',
              Icon(Icons.assignment, color: Colors.blue[800], size: 26),
            ),
            const Divider(color: Colors.grey, thickness: 1),
            profileOptions(
              'Billing',
              Icon(Icons.query_builder, size: 26, color: Colors.blue[800]),
            ),
            const Divider(color: Colors.grey, thickness: 1),
            profileOptions(
              'FAQ',
              Icon(Icons.question_mark, color: Colors.blue[800], size: 26),
            ),
            const Divider(color: Colors.grey, thickness: 1),
          ],
        ),
      ),
    );
  }
}
