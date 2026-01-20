import 'package:dira/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/services/github_service.dart';
import 'widgets/common/primary_button.dart';
import 'widgets/github_connection_bottom_sheet.dart';
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
  final GitHubService _gitHubService = GitHubService();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the deep link listener early
    _initializeGitHubListener();
  }

  void _initializeGitHubListener() {
    _gitHubService.initDeepLinkListener(
      onSuccess: (token, user) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully connected as ${user['login']}!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to home screen
        context.go('/home');
      },
      onError: (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('GitHub connection failed: $error'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _gitHubService.dispose();
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipToConnect() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _showGitHubConnectSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) =>
          GitHubConnectBottomSheet(gitHubService: _gitHubService),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              // Page View
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  WelcomePage(currentPage: _currentPage),
                  FeaturesPage(currentPage: _currentPage),
                  ConnectPage(
                    currentPage: _currentPage,
                    onSkip: _skipToConnect,
                  ),
                ],
              ),

              // Carousel Indicators
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      if (_currentPage == 0)
                        Column(
                          children: [
                            PrimaryButton(
                              text: 'Get Started',
                              onPressed: _nextPage,
                              showArrow: true,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                context.push('/login');
                              },
                              child: const Text(
                                'I already have an account',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_currentPage == 1)
                        PrimaryButton(text: 'Continue', onPressed: _nextPage),
                      if (_currentPage == 2)
                        Column(
                          children: [
                            PrimaryButton(
                              text: 'Connect GitHub',
                              onPressed: _showGitHubConnectSheet,
                              icon: Icons.code,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Read-only access to public repositories',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                context.go('/home');
                              },
                              child: const Text(
                                'I\'ll do this later',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (_currentPage < 2)
                        TextButton(
                          onPressed: _skipToConnect,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
