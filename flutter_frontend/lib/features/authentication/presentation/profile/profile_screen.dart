import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/common_widgets/custom_solid_button.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';
import 'package:junction23/features/routing/app_router.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileScreen({super.key, required this.userModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.userModel.email),
        Text(widget.userModel.name),
        CustomSolidButton(
            text: "Sign Out",
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((value) => context.pushNamed(AppRouting.login));
            })
      ],
    );
  }
}
