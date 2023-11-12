import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:junction23/constants/app_spacing.dart';
import 'package:junction23/constants/design.dart';
import 'package:junction23/features/activity/domain/activity_model.dart';
import 'package:junction23/features/activity/providers/activity_provider.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';

class ActivityOverviewScreen extends ConsumerWidget {
  final UserModel userModel;
  ActivityOverviewScreen({super.key, required this.userModel});

  final List<Color> colors = [primaryColor, secondaryColor, tertiaryColor];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userActivities = ref.watch(activityProvider);

    return Scaffold(
      body: userActivities.when(
        data: (activities) {
          print(activities);
          // Display the retrieved activity data here
          return ListView.builder(
              itemCount: activities.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Center(
                        child: Text(
                          "Daily Challenges",
                          style: TextStyle(color: Colors.white, fontSize: h5),
                        ),
                      ));
                }

                index = index - 1;
                final activity = activities[index];
                return Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Spacing.p16, Spacing.p16, Spacing.p16, Spacing.p16),
                    child: challengeContainer(activity, colors[index]));
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

  Widget challengeContainer(ActivityModel activityModel, Color color) {
    String text = activityModel.assoc_skill == "walking"
        ? "1.152\nSchritte"
        : activityModel.assoc_skill == "swimming"
            ? "12\nMinutes"
            : "13\nKilometer";
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 67, 67, 67),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding:
                    const EdgeInsets.fromLTRB(Spacing.p16, 0, Spacing.p16, 0),
                child: Text(
                  "${activityModel.assoc_skill}                              Durchschnitt:${text}: ${(activityModel.targetValue * activityModel.progress).toInt()}",
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16),
                )),
            Padding(
                padding:
                    const EdgeInsets.fromLTRB(Spacing.p16, 0, Spacing.p16, 8),
                child: LinearProgressIndicator(
                  value: activityModel.progress,
                  backgroundColor: Color.fromARGB(255, 212, 223, 224),
                  color: color,
                  minHeight: 24,
                  borderRadius: BorderRadius.circular(8),
                )),
          ]),
    );
  }
}
