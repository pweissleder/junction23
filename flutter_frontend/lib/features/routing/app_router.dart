import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';
import 'package:junction23/features/authentication/presentation/login_screen.dart';
import 'package:junction23/features/authentication/presentation/profile/profile_screen.dart';
import 'package:junction23/features/authentication/presentation/sign_up_screen.dart';
import 'package:junction23/home_screen.dart';

class AppRouting {
  static String home = "/";
  static String login = 'login';
  static String signUp = 'signUp';
  static String profie = 'profile';
  static String activity = 'activity';
  static String avatar = 'avatar';

  static GoRouter router = GoRouter(
    initialLocation: "/",
    routes: <GoRoute>[
      GoRoute(
          name: home,
          path: home,
          pageBuilder: (context, state) =>
              const MaterialPage(child: HomeScreen()),
          routes: [
            GoRoute(
              path: login,
              name: login,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: LoginScreen()),
            ),
            GoRoute(
              path: signUp,
              name: signUp,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: SignUpScreen()),
            ),
            GoRoute(
                path: profie,
                name: profie,
                pageBuilder: (context, state) {
                  UserModel userModel = state.extra as UserModel;
                  return MaterialPage(
                      child: ProfileScreen(
                    userModel: userModel,
                  ));
                }),
            GoRoute(
                path: activity,
                name: activity,
                pageBuilder: (context, state) {
                  UserModel userModel = state.extra as UserModel;
                  return MaterialPage(
                      child: ProfileScreen(
                    userModel: userModel,
                  ));
                }),
            GoRoute(
                path: avatar,
                name: avatar,
                pageBuilder: (context, state) {
                  UserModel userModel = state.extra as UserModel;
                  return MaterialPage(
                      child: ProfileScreen(
                    userModel: userModel,
                  ));
                }),
          ]),
    ],
  );
}
