import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:junction23/features/activity/domain/activity_model.dart';
import 'package:junction23/features/activity/providers/activity_provider.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';

class ActivityOverviewScreen extends ConsumerWidget {
  final UserModel userModel;
  const ActivityOverviewScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userActivities = ref.watch(activityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Screen'),
      ),
      body: userActivities.when(
        data: (activities) {
          // Display the retrieved activity data here
          return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  title: Text(activity.category),
                );
              });
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) {
          return Center(
            child: Text("Error: $error"),
          );
        },
      ),
    );
  }
}
