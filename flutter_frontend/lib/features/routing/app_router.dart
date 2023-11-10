import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:junction23/features/authentication/presentation/login_screen.dart';
import 'package:junction23/features/authentication/presentation/sign_up_screen.dart';
import 'package:junction23/home_screen.dart';

class AppRouting {
  static String login = 'login';
  static String signUp = 'signUp';

  static GoRouter router = GoRouter(
    initialLocation: "/",
    routes: <GoRoute>[
      GoRoute(
          path: "/",
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
          ]),
    ],
  );
}
