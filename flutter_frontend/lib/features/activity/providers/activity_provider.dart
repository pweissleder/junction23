import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:junction23/features/activity/domain/activity_model.dart';

List<String> activities = ["walking", "swimming", "team_sports"];

final activityProvider =
    FutureProvider.autoDispose<List<ActivityModel>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User not authenticated");
  }

  final userId = user.uid;
  final List<ActivityModel> activityList = [];

  for (String activityName in activities) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('activities')
        .doc(activityName)
        .get();

    if (querySnapshot.exists) {
      final data = querySnapshot.data() as Map<String, dynamic>;
      switch (activityName) {
        case 'walking':
          activityList.add(WalkingActivityModel.fromJson(data));
          break;
        case 'swimming':
          activityList.add(SwimmingActivityModel.fromJson(data));
          break;
        case 'team_sports':
          activityList.add(TeamSportsActivityModel.fromJson(data));
          break;
        default:
          throw Exception("Unsupported activity category");
      }
    } else {
      // Handle the case where the activity data doesn't exist for the user
      // You can choose to skip this activity or handle it differently
    }
  }

  if (activityList.isNotEmpty) {
    return activityList;
  } else {
    throw Exception("No activities found for the user");
  }
});
