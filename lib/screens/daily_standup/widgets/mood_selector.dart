import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodChanged;

  const MoodSelector({
    Key? key,
    required this.selectedMood,
    required this.onMoodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MoodButton(
          emoji: '😊',
          label: 'Happy',
          value: 'happy',
          isSelected: selectedMood == 'happy',
          onTap: () => onMoodChanged('happy'),
        ),
        const SizedBox(width: 12),
        MoodButton(
          emoji: '😐',
          label: 'Medium',
          value: 'medium',
          isSelected: selectedMood == 'medium',
          onTap: () => onMoodChanged('medium'),
        ),
        const SizedBox(width: 12),
        MoodButton(
          emoji: '😔',
          label: 'Low',
          value: 'low',
          isSelected: selectedMood == 'low',
          onTap: () => onMoodChanged('low'),
        ),
      ],
    );
  }
}

class MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodButton({
    Key? key,
    required this.emoji,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.black : AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
