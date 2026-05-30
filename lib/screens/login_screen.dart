import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedRole = '';

  final String _adminEmail = 'areeshasadaf56@gmail.com';
  final String _adminPassword = 'areesha';

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please fill all fields');
      return;
    }

    // Admin role
    if (_selectedRole == 'admin') {
      if (_emailController.text.trim() != _adminEmail ||
          _passwordController.text.trim() != _adminPassword) {
        setState(() => _errorMessage = 'Invalid admin credentials!');
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            email: _emailController.text.trim(),
            isAdmin: _selectedRole == 'admin',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No account found!';
      } else if (e.code == 'wrong-password')
        message = 'Wrong password!';
      else if (e.code == 'invalid-email')
        message = 'Invalid email!';
      else if (e.code == 'invalid-credential')
        message = 'Wrong email or password!';
      else if (e.code == 'too-many-requests')
        message = 'Too many attempts. Try later!';
      else
        message = e.message ?? 'Login failed';
      setState(() {
        _isLoading = false;
        _errorMessage = message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
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
            colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.highlight.withValues(alpha: 0.1),
                      border: Border.all(color: AppColors.highlight, width: 2),
                    ),
                    child: const Icon(Icons.security,
                        size: 45, color: AppColors.highlight),
                  ),
                  const SizedBox(height: 16),
                  const Text('Welcome Back',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
                  const SizedBox(height: 6),
                  const Text('Choose how you want to login',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.greyText)),

                  const SizedBox(height: 30),

                  // ✅ Role Selection
                  if (_selectedRole.isEmpty) ...[
                    const Text('Login As',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // User Card
                    GestureDetector(
                      onTap: () => setState(() => _selectedRole = 'user'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color:
                                  AppColors.highlight.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.highlight.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person,
                                  color: AppColors.highlight, size: 30),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('Access your personal dashboard',
                                    style: TextStyle(
                                        color: AppColors.greyText,
                                        fontSize: 12)),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios,
                                color: AppColors.highlight, size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Admin Card
                    GestureDetector(
                      onTap: () => setState(() => _selectedRole = 'admin'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.admin_panel_settings,
                                  color: AppColors.error, size: 30),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Admin',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('Access admin control panel',
                                    style: TextStyle(
                                        color: AppColors.greyText,
                                        fontSize: 12)),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios,
                                color: AppColors.error, size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ",
                            style: TextStyle(color: AppColors.greyText)),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegisterScreen())),
                          child: const Text('Register',
                              style: TextStyle(
                                  color: AppColors.highlight,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ]

                  // ✅ Login Form
                  else ...[
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedRole == 'admin'
                            ? AppColors.error.withValues(alpha: 0.15)
                            : AppColors.highlight.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedRole == 'admin'
                              ? AppColors.error
                              : AppColors.highlight,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _selectedRole == 'admin'
                                ? Icons.admin_panel_settings
                                : Icons.person,
                            color: _selectedRole == 'admin'
                                ? AppColors.error
                                : AppColors.highlight,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedRole == 'admin'
                                ? 'Admin Login'
                                : 'User Login',
                            style: TextStyle(
                              color: _selectedRole == 'admin'
                                  ? AppColors.error
                                  : AppColors.highlight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: AppColors.greyText),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.highlight),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.highlight, width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: AppColors.greyText),
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.highlight),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _passwordVisible = !_passwordVisible),
                          child: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.greyText),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.highlight, width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Error
                    if (_errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(_errorMessage,
                                    style: const TextStyle(
                                        color: AppColors.error, fontSize: 13))),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen())),
                        child: const Text('Forgot Password?',
                            style: TextStyle(
                                color: AppColors.highlight, fontSize: 13)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedRole == 'admin'
                              ? AppColors.error
                              : AppColors.highlight,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2.5)),
                                  SizedBox(width: 12),
                                  Text('Logging in...',
                                      style: TextStyle(color: AppColors.white)),
                                ],
                              )
                            : const Text('LOGIN',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Back button
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedRole = '';
                        _errorMessage = '';
                        _emailController.clear();
                        _passwordController.clear();
                      }),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios,
                              color: AppColors.greyText, size: 14),
                          Text('Choose different role',
                              style: TextStyle(
                                  color: AppColors.greyText, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
