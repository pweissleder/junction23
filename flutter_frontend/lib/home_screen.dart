import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/constants/design.dart';
import 'package:junction23/features/activity/presentation/activity_overview_screen.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:junction23/features/authentication/presentation/profile/profile_screen.dart';
import 'package:junction23/features/character/presentation/avatar_screen.dart';
import 'package:junction23/features/sensors/data/get_sensor_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserModel?> _getCurrentUser = getCurrentUser();

  int contentIndex = 0;
  StepSimulator simulator = StepSimulator();

  @override
  void initState() {
    super.initState();
    _getCurrentUser = getCurrentUser();
    simulator.stepStream.listen((stepData) {
      print(
          'Total Steps: ${stepData.totalSteps}, Timestamp: ${stepData.timestamp}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FutureBuilder(
            future: _getCurrentUser,
            builder: ((context, snapshot) {
              // if snapshot has data convert snapshot to UserModel and show full app
              if (snapshot.hasData) {
                // if snapshot has user show home screen
                UserModel userModel = snapshot.data as UserModel;

                switch (contentIndex) {
                  case 0:
                    return AvatarScreen(userModel: userModel);
                  case 1:
                    return ActivityOverviewScreen(userModel: userModel);
                  case 2:
                    return ProfileScreen(userModel: userModel);
                }
              }

              // if snapshot is loading show progress indicator
              return const Center(child: CircularProgressIndicator());
            }))
      ]),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Iconify(
            Mdi.cat,
            size: 35,
          ),
          label: 'Avatar',
        ),
        BottomNavigationBarItem(
          icon: Iconify(
            Twemoji.flexed_biceps,
            color: black,
            size: 30,
          ),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: black,
            size: 35,
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: contentIndex,
      selectedItemColor: Colors.amber[800],
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: h7 + 2),
      unselectedFontSize: h7 + 2,
      onTap: (index) {
        setState(() {
          switch (index) {
            case 0:
              contentIndex = 0;
              break;
            case 1:
              contentIndex = 1;
              break;
            case 2:
              contentIndex = 2;
              break;
          }
        });
      },
    );
  }

  Future<UserModel?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // get User Model from firebase
      UserModel userModel = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        return UserModel.fromJson(value.data()!);
      });
      return userModel;
    }
    Future.delayed(Duration.zero, () {
      context.push("/login");
    });

    return null;
  }
}
