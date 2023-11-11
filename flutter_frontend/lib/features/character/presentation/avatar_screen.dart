import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junction23/constants/app_spacing.dart';
import 'package:junction23/constants/design.dart';
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

  List<String> armPositions = [
    body_large_arms_down,
    body_large_arms_normal,
    body_large_arms_up
  ];

  int armIndex = 0;
  bool increasing = true;

  @override
  void initState() {
    super.initState();
    armAnimation();
  }

  @override
  Widget build(BuildContext context) {
    // get screen height and width
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
            top: screenHeight * 0.4,
            left: Spacing.p16,
            child: Image.asset(
              armPositions[armIndex],
              scale: 5,
            )),
        Positioned(
            top: screenHeight * 0.4,
            left: Spacing.p16,
            child: Image.asset(
              happy_face,
              scale: 5,
            ))
      ],
    );
  }

  void armAnimation() {
    Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      setState(() {
        if (increasing) {
          armIndex = (armIndex + 1) % (armPositions.length);
          if (armIndex == armPositions.length - 1) {
            increasing = false;
          }
        } else {
          armIndex = (armIndex - 1) % (armPositions.length);
          if (armIndex == 0) {
            increasing = true;
          }
        }
      });
    });
  }
}
