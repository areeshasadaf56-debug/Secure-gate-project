// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                // ── TOP NAV ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.security,
                              color: AppColors.highlight, size: 28),
                          SizedBox(width: 8),
                          Text('Secure Gate',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginScreen())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.highlight),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Login',
                              style: TextStyle(
                                  color: AppColors.highlight,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── HERO SECTION ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          // Glowing Shield
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.highlight.withValues(alpha: 0.1),
                              border: Border.all(
                                  color: AppColors.highlight, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.highlight
                                      .withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.security,
                                size: 60, color: AppColors.highlight),
                          ),

                          const SizedBox(height: 30),

                          const Text('SECURE GATE',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4)),

                          const SizedBox(height: 12),

                          const Text(
                            'Next-Generation Authentication\n& Access Control System',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: 16,
                                height: 1.6),
                          ),

                          const SizedBox(height: 40),

                          // ── GET STARTED BUTTON ──
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RegisterScreen())),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.highlight,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 8,
                                shadowColor:
                                    AppColors.highlight.withValues(alpha: 0.5),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Get Started',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen())),
                            child: const Text(
                                'Already have an account? Login →',
                                style: TextStyle(
                                    color: AppColors.highlight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // ── FEATURES ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text('Why Secure Gate?',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text('Enterprise-level security for everyone',
                            style: TextStyle(
                                color: AppColors.greyText, fontSize: 14)),
                      ),
                      const SizedBox(height: 30),
                      _featureCard(
                        Icons.lock,
                        'Two-Factor Authentication',
                        'OTP verification after login ensures only you can access your account',
                      ),
                      const SizedBox(height: 16),
                      _featureCard(
                        Icons.people,
                        'Role-Based Access Control',
                        'Admin and User roles with different permissions and dashboards',
                      ),
                      const SizedBox(height: 16),
                      _featureCard(
                        Icons.history,
                        'Activity Monitoring',
                        'Real-time tracking of all login attempts and security events',
                      ),
                      const SizedBox(height: 16),
                      _featureCard(
                        Icons.email,
                        'Secure Password Reset',
                        'Firebase-powered email reset link sent directly to your inbox',
                      ),
                      const SizedBox(height: 16),
                      _featureCard(
                        Icons.chat_bubble_outline,
                        'AI Security Assistant',
                        'Smart chatbot to guide users through security questions',
                      ),
                      const SizedBox(height: 16),
                      _featureCard(
                        Icons.shield,
                        'Firebase Authentication',
                        'Industry-standard secure backend — passwords never stored in plain text',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // ── STATS ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.highlight.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text('Trusted Security',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem('2FA', 'Protection'),
                          _divider(),
                          _statItem('RBAC', 'Access Control'),
                          _divider(),
                          _statItem('100%', 'Secure'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // ── HOW IT WORKS ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Text('How It Works',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      _stepItem('1', 'Register',
                          'Create your account with email and password'),
                      _stepItem('2', 'OTP Verify',
                          'Verify your identity with 6-digit OTP'),
                      _stepItem('3', 'Access Dashboard',
                          'Access your personalized secure dashboard'),
                      _stepItem('4', 'Stay Protected',
                          'All activity monitored and logged'),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // ── BOTTOM CTA ──
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.highlight.withValues(alpha: 0.3),
                        AppColors.accent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.highlight.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.security,
                          size: 50, color: AppColors.highlight),
                      const SizedBox(height: 16),
                      const Text('Ready to Stay Secure?',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Join Secure Gate today — free forever',
                          style: TextStyle(color: AppColors.greyText)),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegisterScreen())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.highlight,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Create Free Account',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── FOOTER ──
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.security,
                              color: AppColors.highlight, size: 18),
                          SizedBox(width: 6),
                          Text('Secure Gate',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Built with Flutter & Firebase',
                          style: TextStyle(
                              color: AppColors.greyText, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('© 2026 Secure Gate — Bahria University Project',
                          style: TextStyle(
                              color: AppColors.greyText, fontSize: 11)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.highlight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.highlight, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.highlight,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: AppColors.greyText, fontSize: 12)),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.highlight.withValues(alpha: 0.3),
    );
  }

  Widget _stepItem(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.highlight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
