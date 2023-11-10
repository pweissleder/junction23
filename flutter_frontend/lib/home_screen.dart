import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(children: []),
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
}
