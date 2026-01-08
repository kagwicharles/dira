import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final int currentPage;

  const WelcomePage({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2F2A), Color(0xFF0F3D36)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Icon Section
            _buildModernIcon(),
            const SizedBox(height: 60),
            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(text: 'Ditch the '),
                        TextSpan(
                          text: 'Boring',
                          style: TextStyle(
                            color: Color(0xFF7FD957),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: '\nMeetings'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Automate your daily standup with GitHub activity.\nSpend less time talking, more time shipping.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CA3AF),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildModernIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main circle
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7FD957), Color(0xFF5FB83D)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7FD957).withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.rocket_launch_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
