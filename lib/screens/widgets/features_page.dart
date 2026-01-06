import 'package:flutter/material.dart';
import 'common/page_indicator.dart';
import 'common/primary_button.dart';
import 'feature_item.dart';

class FeaturesPage extends StatelessWidget {
  final int currentPage;
  final VoidCallback onContinue;

  const FeaturesPage({
    Key? key,
    required this.currentPage,
    required this.onContinue,
  }) : super(key: key);

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
          children: [
            const SizedBox(height: 20),
            const Text(
              'App Features',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'What you get',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Supercharge your daily workflow with\ntools built for developers.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9CA3AF),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const FeatureItem(
                      icon: Icons.flash_on,
                      title: 'Effortless Standups',
                      description:
                          'Sync your status in seconds. No more 30-minute meetings that should have been emails.',
                    ),
                    const SizedBox(height: 32),
                    const FeatureItem(
                      icon: Icons.code,
                      title: 'GitHub Integration',
                      description:
                          'Auto-fill your update with yesterday\'s commits and PRs directly from your repos.',
                    ),
                    const SizedBox(height: 32),
                    const FeatureItem(
                      icon: Icons.track_changes,
                      title: 'Daily Focus',
                      description:
                          'Set one main goal and crush it. Keep the team aligned on what truly matters.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  PageIndicator(currentPage: currentPage, totalPages: 3),
                  const SizedBox(height: 30),
                  PrimaryButton(text: 'Continue', onPressed: onContinue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
