import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
            )),
        Positioned(
            top: 200,
            child: ElevatedButton(
                onPressed: fetchDataFromServer,
                child: Text("Fetch data from server"))),
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

  Future<void> fetchDataFromServer() async {
    final serverUrl =
        'http://172.20.10.4:5000'; // Replace with your server's URL

    try {
      final response = await http.get(Uri.parse('$serverUrl'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON data
        final data = jsonDecode(response.body);
        print('Received data: $data');
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data from the server');
      }
    } catch (error) {
      // Handle any network or server errors
      print('Error: $error');
    }
  }
}
