import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';
import 'package:junction23/features/routing/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserModel?> _getCurrentUser = getCurrentUser();

  @override
  void initState() {
    super.initState();
    _getCurrentUser = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(children: [
        FutureBuilder(
            future: _getCurrentUser,
            builder: ((context, snapshot) {
              // if snapshot has data convert snapshot to UserModel and show full app
              if (snapshot.hasData) {
                // if it is null navigate to login screen
                if (snapshot.data == null) {
                  print("here");
                  Navigator.pushNamed(context, AppRouting.signUp);
                }
                // if snapshot has user show home screen

                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('Welcome'),
                      const SizedBox(height: 20),
                      Text(snapshot.data!.name),
                      const SizedBox(height: 20),
                      Text(snapshot.data!.email),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
              }

              // if snapshot is loading show progress indicator
              return const Center(child: CircularProgressIndicator());
            }))
      ]),
      bottomNavigationBar: customBottomNavigationBar(),
    );
  }

  BottomNavigationBar customBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.deepPurple,
      onTap: (index) {},
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
