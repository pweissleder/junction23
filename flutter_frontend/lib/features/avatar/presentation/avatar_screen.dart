import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:junction23/common_widgets/custom_solid_button.dart';
import 'package:junction23/constants/app_spacing.dart';
import 'package:junction23/constants/design.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';
import 'package:junction23/features/authentication/providers/user_provider.dart';
import 'package:colorful_iconify_flutter/icons/noto.dart';

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

  List<String> facePositions = [
    happy_face,
    neutral_face,
    sad_face,
  ];
  double wellbeingScore = 0.2;

  int armIndex = 0;
  bool increasing = true;
  bool increasing2 = true;
  late Timer _timer;
  late StreamSubscription<DocumentSnapshot> userSubscription;

  int score = 0;
  @override
  void initState() {
    super.initState();
    _startArmAnimation();
    _startFirestoreListener();
    _wellbeingAnimation();
  }

  void _startFirestoreListener() {
    userSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        // Handle the updated data
        _handleUserDataUpdate(snapshot.data());
      }
    });
  }

  void _handleUserDataUpdate(Map<String, dynamic>? userData) {
    // Update your state based on the userData
    if (userData != null && userData.containsKey('coins')) {
      if (widget.userModel.coins < userData['coins']) {
        setState(() {
          score = userData['coins'] - widget.userModel.coins;
          widget.userModel.coins = userData['coins'];
        });
        _showCoinsPopup();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    userSubscription.cancel(); // Cancel the Firestore subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get screen height and width
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print(wellbeingScore);
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: Image.asset(
              "assets/bg13.png",
              width: screenWidth,
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 280),
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
                TextButton(
                    onPressed: () {},
                    child: customCircularProgress(
                        wellbeingScore, "Wellbeing", tertiaryColor))
              ],
            ),
            gapH40,
            CustomSolidButton(
              text: "Start minigame",
              onPressed: () {
                runPythonScript();
              },
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
              wellbeingScore < 0.3
                  ? facePositions[2]
                  : wellbeingScore < 0.7
                      ? facePositions[1]
                      : facePositions[0],
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

  void _wellbeingAnimation() {
    const duration = Duration(milliseconds: 700);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (mounted) {
        setState(() {
          if (increasing2) {
            wellbeingScore += 0.05;
            if (wellbeingScore >= 1) {
              wellbeingScore = 1;
              increasing2 = false;
            }
          } else {
            wellbeingScore -= 0.05;
            if (wellbeingScore <= 0) {
              wellbeingScore = 0;
              increasing2 = true;
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

  void _showCoinsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(score <= 1
              ? 'HEY YOU WON $score COIN!'
              : 'HEY YOU WON $score COINS!'),
          content: SizedBox(
              height: 180,
              child: Column(children: [
                const Iconify(
                  Noto.trophy,
                  size: 80,
                ),
                gapH16,
                CustomSolidButton(
                  text: "Go to shop",
                  onPressed: () {},
                  gradient: gradient1,
                )
              ])),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> runPythonScript() async {
    try {
      var url = Uri.parse('http://10.0.13.142:5000/run-script');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Failed to connect to the server: $e');
    }
  }
}
