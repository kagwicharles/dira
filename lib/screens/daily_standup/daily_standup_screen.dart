import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/common/primary_button.dart';
import 'widgets/mood_selector.dart';
import 'widgets/task_card.dart';

class DailyStandupScreen extends StatefulWidget {
  const DailyStandupScreen({Key? key}) : super(key: key);

  @override
  State<DailyStandupScreen> createState() => _DailyStandupScreenState();
}

class _DailyStandupScreenState extends State<DailyStandupScreen> {
  String selectedMood = 'happy';
  final TextEditingController _blockerController = TextEditingController();

  @override
  void dispose() {
    _blockerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Standup',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'OCT 24, THURSDAY',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    const Text(
                      'Good Morning,\nDev! 👋',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Mood selector
                    const Text(
                      "How's the tank?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    MoodSelector(
                      selectedMood: selectedMood,
                      onMoodChanged: (mood) {
                        setState(() {
                          selectedMood = mood;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    // Blocker input
                    const Text(
                      'Anything affecting timely? (e.g. WIP)',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _blockerController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Yesterday section
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: AppColors.textLight,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Yesterday',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          child: const Text(
                            '3 from github',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const TaskCard(
                      type: 'EPIC',
                      number: 'SUPPY',
                      title:
                          'Implemented user authentication flow with JWT handling.',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    const TaskCard(
                      type: 'FRONTEND',
                      number: 'MOBILE',
                      title: 'Cleaned up API service utility functions.',
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    const TaskCard(
                      type: 'API',
                      number: 'ROUTES',
                      title: 'Patched race condition in loading state.',
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 32),
                    // AI suggestion
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI SUGGESTION',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: const Text(
                                  'Regenerate',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Finish the Auth flow & start integration tests.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Based on high-frequency & yesterday\'s "feat" commits',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: 'Generate Standup',
                onPressed: () {},
                icon: Icons.auto_awesome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
