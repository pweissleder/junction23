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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userModelAsyncValue = ref.watch(currentUserProvider);
    final contentIndex = ref.watch(selectedContentIndexProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 124, 119, 80),
                const Color.fromARGB(255, 224, 218, 198)
              ],

              begin: Alignment.topCenter, // Start from the top center
              end: Alignment.bottomCenter, // End at the bottom center
            ),
          ),
        ),
        backgroundColor: contentIndex == 0
            ? const Color.fromARGB(255, 25, 166, 253)
            : Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: contentIndex == 0
                ? const Color.fromARGB(255, 224, 218, 198)
                : Colors.transparent,
            height: 1.0,
          ),
        ),
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
            Text(
              " Coins: ${userModelAsyncValue.value?.coins ?? 0}",
              style: const TextStyle(
                  fontSize: h7, fontWeight: FontWeight.bold, color: black),
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
      ),
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
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      selectedItemColor: Color.fromARGB(255, 93, 160, 214),
      unselectedItemColor: Colors.white,
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: h7 + 2),
      onTap: (index) {
        ref.read(selectedContentIndexProvider.notifier).state = index;
      },
    );
  }
}
