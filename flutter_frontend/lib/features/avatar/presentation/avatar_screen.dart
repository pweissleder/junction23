import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:junction23/common_widgets/custom_solid_button.dart';
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
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _startArmAnimation();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get screen height and width
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 230),
            Text(
              widget.userModel.name,
              style: const TextStyle(fontSize: h5),
            ),
            const Text(
              "Level: ${11}",
              style: TextStyle(fontSize: h6),
            ),
            gapH24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                customCircularProgress(0.9, "Health", primaryColor),
                customCircularProgress(0.6, "Activity", secondaryColor),
                customCircularProgress(0.1, "Wellbeing", tertiaryColor)
              ],
            ),
            gapH40,
            CustomSolidButton(
              text: "Start minigame",
              onPressed: () {},
              gradient: gradient1,
            )
          ],
        ),
        Positioned(
            top: 0,
            left: 40,
            child: Image.asset(
              armPositions[armIndex],
              scale: 6,
            )),
        Positioned(
            top: 0,
            left: 40,
            child: Image.asset(
              happy_face,
              scale: 6,
            )),
      ],
    );
  }

  void _startArmAnimation() {
    const duration = Duration(milliseconds: 300);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (mounted) {
        setState(() {
          if (increasing) {
            armIndex = (armIndex + 1) % armPositions.length;
            if (armIndex == armPositions.length - 1) {
              increasing = false;
            }
          } else {
            armIndex = (armIndex - 1) % armPositions.length;
            if (armIndex == 0) {
              increasing = true;
            }
          }
        });
      } else {
        // Widget is no longer in the tree, cancel the timer
        timer.cancel();
      }
    });
  }

  Widget customCircularProgress(double progress, String text, Color color) {
    double stroke = 9;
    double diameter = 60;
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: diameter,
              height: diameter,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent, // Transparent background
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.grey), // Fill color
                strokeWidth: stroke, // Adjust the thickness of the circle
                value: 1, // Set the progress value (0.0 to 1.0)
              ),
            ),
            SizedBox(
              width: diameter,
              height: diameter,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent, // Transparent background
                valueColor: AlwaysStoppedAnimation<Color>(color), // Fill color
                strokeWidth: stroke, // Adjust the thickness of the circle
                value: progress, // Set the progress value (0.0 to 1.0)
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Text((100 * progress).toInt().toString(),
                  style: const TextStyle(
                      fontSize: h7, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        gapH8,
        Text(text,
            style: const TextStyle(fontSize: h7, fontWeight: FontWeight.bold))
      ],
    );
  }
}
