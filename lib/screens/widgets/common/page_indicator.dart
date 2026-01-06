import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == currentPage
                ? AppColors.primary
                : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
