import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/features/activity/presentation/activity_overview_screen.dart';
import 'package:junction23/features/authentication/presentation/profile/profile_screen.dart';
import 'package:junction23/features/authentication/providers/user_provider.dart';
import 'package:junction23/features/avatar/presentation/avatar_screen.dart';
import 'package:junction23/features/routing/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsyncValue = ref.watch(currentUserProvider);
    final contentIndex = ref.watch(selectedContentIndexProvider);

    return Scaffold(
      body: Stack(
        children: [
          userModelAsyncValue.when(
            data: (userModel) {
              if (userModel == null) {
                // Navigate to login screen when userModel is null
                Future.microtask(() {
                  context.pushNamed(AppRouting.login);
                });

                return const SizedBox(); // Return an empty widget while navigating
              }
              switch (contentIndex) {
                case 0:
                  return AvatarScreen(userModel: userModel);
                case 1:
                  return ActivityOverviewScreen(
                    userModel: userModel,
                  );
                case 2:
                  return ProfileScreen(userModel: userModel);
                default:
                  return const SizedBox(); // Handle other cases as needed
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              // Handle error
              return Center(child: Text("Error: $error"));
            },
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(context, contentIndex, ref),
    );
  }

  BottomNavigationBar bottomNavigationBar(
      BuildContext context, int contentIndex, WidgetRef ref) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Avatar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: contentIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {
        ref.read(selectedContentIndexProvider.notifier).state = index;
      },
    );
  }
}
