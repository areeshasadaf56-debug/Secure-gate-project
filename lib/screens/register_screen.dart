import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;
  bool _registered = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill all fields');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set display name
      await cred.user?.updateDisplayName(name);
      await cred.user?.reload();

      // Send verification email
      await cred.user?.sendEmailVerification();

      // Sign out so user must verify before using app
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _registered = true;
      });
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use!';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email!';
      } else if (e.code == 'weak-password') {
        message = 'Weak password!';
      } else {
        message = e.message ?? 'Registration failed';
      }

      if (!mounted) return;
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

  Future<void> _resendVerificationEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // To resend, we need a logged-in user. We'll sign in briefly, send, then sign out.
    if (email.isEmpty || password.isEmpty) {
      setState(() =>
          _errorMessage = 'Please enter email + password again to resend.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user?.sendEmailVerification();
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _registered = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Could not resend email. Try login then resend from profile.';
      });
    }
  }

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
      ),
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
          child: _registered ? _successScreen() : _formScreen(),
        ),
      ),
    );
  }

  Widget _successScreen() {
    final email = _emailController.text.trim();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_read,
                size: 80, color: AppColors.success),
            const SizedBox(height: 20),
            const Text(
              "Verify Your Email",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "A verification email has been sent to:\n$email\n\nOpen your email, click the link, then login.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.greyText),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text("Go to Login"),
              ),
            ),

            const SizedBox(height: 12),

            // Optional: resend button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _resendVerificationEmail,
                child: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Resend verification email"),
              ),
            ),

            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _formScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.person_add, size: 70, color: AppColors.highlight),
          const SizedBox(height: 20),
          const Text(
            "Create Account",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _input(_nameController, "Full Name"),
          const SizedBox(height: 12),
          _input(_emailController, "Email"),
          const SizedBox(height: 12),
          _passwordInput(),
          const SizedBox(height: 20),
          if (_errorMessage.isNotEmpty)
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("REGISTER"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String label) {
    return TextField(
      controller: c,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.greyText),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  Widget _passwordInput() {
    return TextField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: AppColors.greyText),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.greyText,
          ),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }
}
