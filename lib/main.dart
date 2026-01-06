import 'package:dira/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/daily_standup/daily_standup_screen.dart';
import 'screens/github_integration/github_integration_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(
      path: '/github-integration',
      builder: (context, state) => const GitHubIntegrationScreen(),
    ),
    GoRoute(
      path: '/daily-standup',
      builder: (context, state) => const DailyStandupScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StandUp.io',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Inter',
      ),
      routerConfig: _router,
    );
  }
}
