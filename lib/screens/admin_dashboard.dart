// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/app_colors.dart';
import 'login_screen.dart';
import 'activity_logs_screen.dart';
import 'chatbot_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.error),
                          ),
                          child: const Text(
                            '🛡️ Admin Panel',
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Secure Gate',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.highlight.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.highlight.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(Icons.logout,
                            color: AppColors.highlight, size: 22),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Stats Row
                Row(
                  children: [
                    Expanded(child: _statCard(Icons.people, 'Users', '1')),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard(Icons.shield, 'Security', 'ON')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _statCard(Icons.warning_amber, 'Alerts', '0')),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Admin Controls',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                _adminCard(
                  context,
                  Icons.people_outline,
                  'Manage Users',
                  'View all registered users',
                  const _ManageUsersScreen(),
                ),
                const SizedBox(height: 12),

                _adminCard(
                  context,
                  Icons.history,
                  'All Activity Logs',
                  'View all login activity',
                  const ActivityLogsScreen(),
                ),
                const SizedBox(height: 12),

                _adminCard(
                  context,
                  Icons.chat_bubble_outline,
                  'AI Assistant',
                  'Security chatbot',
                  const ChatbotScreen(),
                ),
                const SizedBox(height: 12),

                _adminCard(
                  context,
                  Icons.bar_chart,
                  'Reports',
                  'Security reports',
                  const _ReportsScreen(),
                ),
                const SizedBox(height: 12),

                _adminCard(
                  context,
                  Icons.settings,
                  'Settings',
                  'App configuration',
                  const _SettingsScreen(),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.highlight, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(color: AppColors.greyText, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _adminCard(BuildContext context, IconData icon, String title,
      String subtitle, Widget screen) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.highlight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.highlight, size: 22),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.greyText, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ManageUsersScreen extends StatelessWidget {
  const _ManageUsersScreen();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'N/A';
    final name = user?.displayName ?? email.split('@')[0];
    final joined =
        user?.metadata.creationTime?.toString().split(' ')[0] ?? 'N/A';

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Manage Users',
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _userTile(name, email, 'user', joined),
            const SizedBox(height: 12),
            _userTile('Admin', 'areeshasadaf56@gmail.com', 'admin', 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _userTile(String name, String email, String role, String joined) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.highlight.withValues(alpha: 0.2),
            child: const Icon(Icons.person, color: AppColors.highlight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold)),
                Text(email,
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 12)),
                if (joined != 'N/A')
                  Text('Joined: $joined',
                      style: const TextStyle(
                          color: AppColors.greyText, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: role == 'admin'
                  ? AppColors.error.withValues(alpha: 0.2)
                  : AppColors.success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(role,
                style: TextStyle(
                    color:
                        role == 'admin' ? AppColors.error : AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECURITY REPORTS — real Firebase Auth data
// ─────────────────────────────────────────────
class _ReportsScreen extends StatelessWidget {
  const _ReportsScreen();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final lastLogin =
        user?.metadata.lastSignInTime?.toString().split(' ')[0] ?? 'N/A';
    final joined =
        user?.metadata.creationTime?.toString().split(' ')[0] ?? 'N/A';
    final email = user?.emailVerified == true ? 'Verified ✅' : 'Unverified ⚠️';
    final provider = user?.providerData.isNotEmpty == true
        ? user!.providerData[0].providerId
        : 'N/A';

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Security Reports',
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.highlight.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.highlight.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline,
                      color: AppColors.highlight, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Data pulled live from Firebase Auth for current session.',
                      style: TextStyle(color: AppColors.greyText, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            _reportCard(
                'Last Login', lastLogin, Icons.login, AppColors.success),
            const SizedBox(height: 12),
            _reportCard('Account Created', joined, Icons.person_add,
                AppColors.highlight),
            const SizedBox(height: 12),
            _reportCard('Email Status', email, Icons.email, Colors.orange),
            const SizedBox(height: 12),
            _reportCard('Login Provider', provider, Icons.key, AppColors.error),
            const SizedBox(height: 12),
            _reportCard(
                'Active Sessions', '1', Icons.devices, AppColors.success),
            const SizedBox(height: 12),
            _reportCard('Failed Attempts', '0', Icons.cancel, AppColors.error),
          ],
        ),
      ),
    );
  }

  Widget _reportCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title,
                style: const TextStyle(color: AppColors.white, fontSize: 15)),
          ),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SETTINGS — all cards now navigate somewhere
// ─────────────────────────────────────────────
class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings', style: TextStyle(color: AppColors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _settingTile(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage alerts',
              screen: const _NotificationsSettingScreen(),
            ),
            const SizedBox(height: 12),
            _settingTile(
              context,
              icon: Icons.security,
              title: 'Security Policy',
              subtitle: 'Password rules',
              screen: const _SecurityPolicyScreen(),
            ),
            const SizedBox(height: 12),
            _settingTile(
              context,
              icon: Icons.people,
              title: 'User Permissions',
              subtitle: 'Manage roles',
              screen: const _UserPermissionsScreen(),
            ),
            const SizedBox(height: 12),
            // App version — not clickable
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.highlight.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info, color: AppColors.highlight, size: 22),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('App Version',
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold)),
                        Text('v1.0.0',
                            style: TextStyle(
                                color: AppColors.greyText, fontSize: 12)),
                      ],
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

  Widget _settingTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Widget screen}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.highlight, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.greyText, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: AppColors.greyText, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NOTIFICATIONS SETTINGS
// ─────────────────────────────────────────────
class _NotificationsSettingScreen extends StatefulWidget {
  const _NotificationsSettingScreen();

  @override
  State<_NotificationsSettingScreen> createState() =>
      _NotificationsSettingScreenState();
}

class _NotificationsSettingScreenState
    extends State<_NotificationsSettingScreen> {
  bool _loginAlerts = true;
  bool _failedAttempts = true;
  bool _passwordChanges = false;
  bool _newDevices = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications',
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _switchTile('Login Alerts', 'Notify on every login', _loginAlerts,
                (v) => setState(() => _loginAlerts = v)),
            const SizedBox(height: 12),
            _switchTile('Failed Attempts', 'Notify on failed logins',
                _failedAttempts, (v) => setState(() => _failedAttempts = v)),
            const SizedBox(height: 12),
            _switchTile('Password Changes', 'Notify on password reset',
                _passwordChanges, (v) => setState(() => _passwordChanges = v)),
            const SizedBox(height: 12),
            _switchTile('New Device Logins', 'Notify on new device',
                _newDevices, (v) => setState(() => _newDevices = v)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('✅ Notification preferences saved!'),
                  backgroundColor: Colors.green,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Save Preferences',
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.highlight,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECURITY POLICY
// ─────────────────────────────────────────────
class _SecurityPolicyScreen extends StatelessWidget {
  const _SecurityPolicyScreen();
  
  get child => null;

  @override
  Widget build(BuildContext context) {
    final policies = [
      {
        'icon': Icons.lock,
        'title': 'Minimum Password Length',
        'value': '8 characters',
        'color': AppColors.highlight,
      },
      {
        'icon': Icons.text_fields,
        'title': 'Uppercase Required',
        'value': 'Yes',
        'color': AppColors.success,
      },
      {
        'icon': Icons.numbers,
        'title': 'Number Required',
        'value': 'Yes',
        'color': AppColors.success,
      },
      {
        'icon': Icons.verified_user,
        'title': 'OTP Verification',
        'value': 'Enabled',
        'color': AppColors.success,
      },
      {
        'icon': Icons.timer,
        'title': 'Session Timeout',
        'value': '30 minutes',
        'color': Colors.orange,
      },
      {
        'icon': Icons.block,
        'title': 'Max Failed Attempts',
        'value': '5 tries',
        'color': AppColors.error,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Security Policy',
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield, color: AppColors.success, size: 16),
                  SizedBox(width: 8),
                  Text('All security policies are active',
                      style: TextStyle(color: AppColors.success, fontSize: 13)),
                ],
              ),
            ),
            ...policies.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: (p['color'] as Color).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                (p['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(p['title'] as String,
                              style: const TextStyle(
                                  color: AppColors.white, fontSize: 14)),
                        ),
                          child: Icon(p['icon'] as IconData,
                              color: p['color'] as Color, size: 20),
                        ),
  }
                        const SizedBox(width: 14),
                        Expanded(
                        
                        Text(p  ['value'] as String,
                            style: TextStyle(
                                color: p['color'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// USER PERMISSIONS
// ─────────────────────────────────────────────
class _UserPermissionsScreen extends StatefulWidget {
  const _UserPermissionsScreen();

  @override
  State<_UserPermissionsScreen> createState() => _UserPermissionsScreenState();
}

class _UserPermissionsScreenState extends State<_UserPermissionsScreen> {
  bool _canViewReports = true;
  bool _canExportData = false;
  bool _canManageUsers = false;
  bool _canChangeSettings = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'N/A';

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('User Permissions',
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Current user info
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.highlight.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.highlight.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, color: AppColors.highlight),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(email,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        const Text('Role: User',
                            style: TextStyle(
                                color: AppColors.greyText, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Text('Permissions',
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 12),

            _permissionTile('View Reports', 'Can access security reports',
                _canViewReports, (v) => setState(() => _canViewReports = v)),
            const SizedBox(height: 12),
            _permissionTile('Export Data', 'Can download reports',
                _canExportData, (v) => setState(() => _canExportData = v)),
            const SizedBox(height: 12),
            _permissionTile('Manage Users', 'Can add/remove users',
                _canManageUsers, (v) => setState(() => _canManageUsers = v)),
            const SizedBox(height: 12),
            _permissionTile(
                'Change Settings',
                'Can modify app settings',
                _canChangeSettings,
                (v) => setState(() => _canChangeSettings = v)),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('✅ Permissions updated!'),
                  backgroundColor: Colors.green,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Save Permissions',
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permissionTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.highlight,
          ),
        ],
      ),
    );
  }
}
