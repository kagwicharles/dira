import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import 'common/page_indicator.dart';
import 'common/primary_button.dart';

class ConnectPage extends StatelessWidget {
  final int currentPage;
  final VoidCallback onSkip;

  const ConnectPage({Key? key, required this.currentPage, required this.onSkip})
    : super(key: key);

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
              'Ready to Connect',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Network visualization placeholder
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Network lines simulation
                          CustomPaint(
                            size: const Size(300, 300),
                            painter: NetworkPainter(),
                          ),
                          // Center sync icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.sync,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Power your Standups',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Connect your GitHub account to\nautomatically populate your daily\nupdates with your latest commits and\npull requests.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9CA3AF),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Connect GitHub',
                    onPressed: () {
                      context.go('/github-integration');
                    },
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
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PageIndicator(currentPage: currentPage, totalPages: 3),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw network lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14159 / 180;
      final endX = center.dx + 100 * (angle.cos());
      final endY = center.dy + 100 * (angle.sin());
      canvas.drawLine(center, Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on double {
  double cos() {
    // Simple approximation for cosine
    final x = this % (2 * 3.14159);
    return 1 - (x * x) / 2 + (x * x * x * x) / 24;
  }

  double sin() {
    // Simple approximation for sine
    return (this + 1.5708).cos();
  }
}
