import 'package:flutter/material.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';

class ActivityOverviewScreen extends StatefulWidget {
  final UserModel userModel;
  const ActivityOverviewScreen({super.key, required this.userModel});

  @override
  State<ActivityOverviewScreen> createState() => _ActivityOverviewScreenState();
}

class _ActivityOverviewScreenState extends State<ActivityOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Activity Overview Screen'),
      ],
    );
  }
}
