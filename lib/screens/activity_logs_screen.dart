import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';

class ActivityLogsScreen extends StatelessWidget {
  const ActivityLogsScreen({super.key});

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'N/A';
    final local = dt.toLocal();
    final hour = local.hour > 12
        ? local.hour - 12
        : local.hour == 0
            ? 12
            : local.hour;
    final amPm = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}  '
        '${hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')} $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'N/A';
    final lastLogin = _formatDateTime(user?.metadata.lastSignInTime);
    final joinDate = _formatDateTime(user?.metadata.creationTime);
    final emailVerified = user?.emailVerified ?? false;

    final List<Map<String, dynamic>> logs = [
      {
        'event': 'Login Successful',
        'detail': email,
        'time': lastLogin,
        'type': 'success',
      },
      {
        'event': 'OTP Verified',
        'detail': '6-digit code verified via EmailJS',
        'time': lastLogin,
        'type': 'success',
      },
      {
        'event': 'Email Status',
        'detail':
            emailVerified ? 'Email is verified ✅' : 'Email not verified ⚠️',
        'time': joinDate,
        'type': emailVerified ? 'success' : 'warning',
      },
      {
        'event': 'Account Created',
        'detail': email,
        'time': joinDate,
        'type': 'info',
      },
    ];

    final successCount = logs.where((l) => l['type'] == 'success').length;
    final warningCount = logs.where((l) => l['type'] == 'warning').length;
    final infoCount = logs.where((l) => l['type'] == 'info').length;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Activity Logs',
            style: TextStyle(color: AppColors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
          ),
        ),
        child: Column(
          children: [
            // Live data banner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.highlight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.highlight.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 8),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Live data · Local time (PKT) · $email',
                        style: const TextStyle(
                            color: AppColors.greyText, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Summary bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _summaryChip(Icons.check_circle, '$successCount Success',
                      AppColors.success),
                  const SizedBox(width: 10),
                  _summaryChip(
                      Icons.warning, '$warningCount Warning', Colors.orange),
                  const SizedBox(width: 10),
                  _summaryChip(
                      Icons.info, '$infoCount Info', AppColors.highlight),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final color = log['type'] == 'success'
                      ? AppColors.success
                      : log['type'] == 'warning'
                          ? Colors.orange
                          : AppColors.highlight;
                  final icon = log['type'] == 'success'
                      ? Icons.check_circle
                      : log['type'] == 'warning'
                          ? Icons.warning_amber
                          : Icons.info_outline;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log['event']!,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(log['detail']!,
                                  style: const TextStyle(
                                      color: AppColors.greyText, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: AppColors.greyText, size: 12),
                                  const SizedBox(width: 4),
                                  Text(log['time']!,
                                      style: const TextStyle(
                                          color: AppColors.greyText,
                                          fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (log['type'] as String).toUpperCase(),
                            style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
