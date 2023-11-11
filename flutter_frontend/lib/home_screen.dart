import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:junction23/constants/design.dart';
import 'package:junction23/features/activity/presentation/activity_overview_screen.dart';
import 'package:junction23/features/authentication/presentation/profile/profile_screen.dart';
import 'package:junction23/features/authentication/providers/user_provider.dart';
import 'package:junction23/features/avatar/presentation/avatar_screen.dart';
import 'package:junction23/features/routing/app_router.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsyncValue = ref.watch(currentUserProvider);
    final contentIndex = ref.watch(selectedContentIndexProvider);

    return Scaffold(
      appBar: customAppBar(),
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
          icon: Icon(Icons.av_timer),
          label: 'Avatar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility),
          label: 'Challenges',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: contentIndex,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      selectedItemColor: const Color.fromARGB(255, 1, 56, 101),
      unselectedItemColor: black,
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: h7 + 2),
      onTap: (index) {
        ref.read(selectedContentIndexProvider.notifier).state = index;
      },
    );
  }

  AppBar customAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 100,
      backgroundColor: Colors.transparent,
      actions: [
        Column(children: [
          IconButton(
            onPressed: () {},
            icon: const Iconify(
              GameIcons.backpack,
              size: 40,
            ),
            color: Colors.black,
          ),
          const Text(
            " Coins: ${112}",
            style: TextStyle(fontSize: h7, fontWeight: FontWeight.bold),
          )
        ]),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Iconify(
            Twemoji.flexed_biceps,
            color: black,
            size: 40,
          ),
          color: Colors.black,
        ),
      ],
    );
  }
}
