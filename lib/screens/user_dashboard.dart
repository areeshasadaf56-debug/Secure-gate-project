// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/app_colors.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'activity_logs_screen.dart';
import 'chatbot_screen.dart';
import 'change_password_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final bool _isAdminView = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            user?.email ?? 'User',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // LOGOUT
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();

                        if (!mounted) return;

                        Navigator.pushAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.highlight.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.highlight.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: AppColors.highlight,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // LOGO
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.highlight.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.highlight,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.security,
                      size: 45,
                      color: AppColors.highlight,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Center(
                  child: Text(
                    'Secure Gate',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    _isAdminView
                        ? '🛡️ Admin Panel Active'
                        : '🔐 You are securely logged in',
                    style: const TextStyle(
                      color: AppColors.greyText,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // USER VIEW
                if (!_isAdminView) ...[
                  _buildCard(
                    context,
                    Icons.person_outline,
                    'Profile',
                    'View your account details',
                    const ProfileScreen(),
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    context,
                    Icons.history,
                    'Activity Logs',
                    'See your login history',
                    ActivityLogsScreen(),
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    context,
                    Icons.chat_bubble_outline,
                    'AI Assistant',
                    'Get security help',
                    const ChatbotScreen(),
                  ),
                  const SizedBox(height: 14),
                  _buildCard(
                    context,
                    Icons.lock_reset,
                    'Change Password',
                    'Update your password',
                    const ChangePasswordScreen(),
                  ),
                ]

                // ADMIN VIEW
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          Icons.people,
                          'Users',
                          '1',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _statCard(
                          Icons.shield,
                          'Security',
                          'ON',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Admin Options',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _adminCard(
                    Icons.people_outline,
                    'Manage Users',
                    'View all registered users',
                  ),
                  const SizedBox(height: 12),
                  _adminCard(
                    Icons.history,
                    'All Activity Logs',
                    'View all login activity',
                  ),
                  const SizedBox(height: 12),
                  _adminCard(
                    Icons.chat_bubble_outline,
                    'AI Assistant',
                    'Security chatbot',
                  ),
                  const SizedBox(height: 12),
                  _adminCard(
                    Icons.bar_chart,
                    'Reports',
                    'Security reports',
                  ),
                  const SizedBox(height: 12),
                  _adminCard(
                    Icons.settings,
                    'Settings',
                    'App configuration',
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.highlight.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.highlight.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.highlight,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.greyText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.highlight.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.highlight.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.highlight,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.greyText,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.highlight.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.highlight,
            size: 26,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.greyText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
