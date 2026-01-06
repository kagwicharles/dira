import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'common/logo_badge.dart';
import 'common/page_indicator.dart';
import 'common/primary_button.dart';

class WelcomePage extends StatelessWidget {
  final int currentPage;
  final VoidCallback onGetStarted;

  const WelcomePage({
    Key? key,
    required this.currentPage,
    required this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A9B8E), Color(0xFFE8F5F3)],
          stops: [0.0, 0.6],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome to Standup App',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoBadge(),
                  const SizedBox(height: 30),
                  // Robot Image Placeholder
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF7FD957), Color(0xFF5FB83D)],
                            ),
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        Positioned(
                          right: 40,
                          bottom: 60,
                          child: Container(
                            width: 60,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                5,
                                (index) => Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 6,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'Ditch the\n'),
                        TextSpan(
                          text: 'Boring',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(text: ' Meetings.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Automate your daily standup with\nGitHub activity. Spend less time\ntalking and more time shipping.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  PageIndicator(currentPage: currentPage, totalPages: 3),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    text: 'Get Started',
                    onPressed: onGetStarted,
                    showArrow: true,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }
}
