import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dira/core/constants/app_colors.dart';
import '../../core/services/github_service.dart';

class GitHubConnectBottomSheet extends StatefulWidget {
  final GitHubService gitHubService;

  const GitHubConnectBottomSheet({Key? key, required this.gitHubService})
    : super(key: key);

  @override
  State<GitHubConnectBottomSheet> createState() =>
      _GitHubConnectBottomSheetState();
}

class _GitHubConnectBottomSheetState extends State<GitHubConnectBottomSheet> {
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _initializeGitHubListener();
  }

  void _initializeGitHubListener() {
    widget.gitHubService.initDeepLinkListener(
      onSuccess: (token, user) {
        if (!mounted) return;

        Navigator.of(context).pop(); // Close the bottom sheet

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully connected as ${user['login']}!'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _isConnecting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  Future<void> _connectGitHub() async {
    setState(() {
      _isConnecting = true;
    });

    try {
      final authUrl = await widget.gitHubService.startOAuthFlow();
      final uri = Uri.parse(authUrl);

      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          throw Exception('Failed to launch browser');
        }

        // Don't close the bottom sheet immediately
        // Let the deep link handler close it on success
      } else {
        throw Exception('Could not launch GitHub authorization URL');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to GitHub: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.cardBackground, AppColors.darkBackground],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),

              // GitHub Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.code, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Connect Your GitHub',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'Sync your GitHub activity to automatically populate your daily standups with commits and pull requests.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),

              // Permissions List
              _buildPermissionItem(
                Icons.person_outline,
                'Your account only',
                'Each developer connects their own GitHub',
              ),
              const SizedBox(height: 16),
              _buildPermissionItem(
                Icons.lock_outline,
                'Secure & private',
                'Your credentials stay on your device',
              ),
              const SizedBox(height: 16),
              _buildPermissionItem(
                Icons.sync_outlined,
                'Auto-sync activity',
                'Keep your standups updated automatically',
              ),
              const SizedBox(height: 16),
              _buildPermissionItem(
                Icons.storage_outlined,
                'Read-only access',
                'We only read your public repositories',
              ),
              const SizedBox(height: 36),

              // Connect Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isConnecting ? null : _connectGitHub,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkBackground,
                    elevation: 0,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isConnecting
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.darkBackground,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.code, size: 22),
                            SizedBox(width: 10),
                            Text(
                              'Connect GitHub',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Cancel Button
              TextButton(
                onPressed: _isConnecting
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(
                  _isConnecting
                      ? 'Waiting for authorization...'
                      : 'I\'ll do this later',
                  style: TextStyle(
                    fontSize: 15,
                    color: _isConnecting
                        ? Colors.grey[600]
                        : AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 22, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
