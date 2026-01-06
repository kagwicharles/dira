import 'package:flutter/material.dart';
import 'widgets/welcome_page.dart';
import 'widgets/features_page.dart';
import 'widgets/connect_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToConnect() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          WelcomePage(
            currentPage: _currentPage,
            onGetStarted: _nextPage,
          ),
          FeaturesPage(
            currentPage: _currentPage,
            onContinue: _nextPage,
          ),
          ConnectPage(
            currentPage: _currentPage,
            onSkip: _skipToConnect,
          ),
        ],
      ),
    );
  }
}