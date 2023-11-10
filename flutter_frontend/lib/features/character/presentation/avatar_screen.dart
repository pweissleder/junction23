import 'package:flutter/material.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';

class AvatarScreen extends StatefulWidget {
  final UserModel userModel;
  const AvatarScreen({super.key, required this.userModel});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  // get screen height and width
  late double screenHeight;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    // get screen height and width
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
            top: screenHeight * 0.4,
            left: screenWidth * 0.3,
            child: Image.asset(
              "assets/happy.png",
              scale: 0.3,
            )),
      ],
    );
  }
}
