import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _done = false;
  String _error = '';

  Future<void> _changePassword() async {
    if (_newPasswordController.text.trim().length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Passwords do not match!');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      await FirebaseAuth.instance.currentUser!
          .updatePassword(_newPasswordController.text.trim());
      setState(() {
        _done = true;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.message ?? 'Failed to update password';
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
          icon: Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            Text('Change Password', style: TextStyle(color: AppColors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: _done
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 80),
                      SizedBox(height: 20),
                      Text('Password Updated!',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Your password has been changed successfully',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.greyText)),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text('Go Back',
                            style: TextStyle(
                                color: AppColors.highlight,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_reset,
                        size: 70, color: AppColors.highlight),
                    SizedBox(height: 20),
                    Text('Change Password',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 36),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      style: TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: AppColors.greyText),
                        prefixIcon: Icon(Icons.lock_outline,
                            color: AppColors.highlight),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color: AppColors.highlight, width: 1.5)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      style: TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: AppColors.greyText),
                        prefixIcon: Icon(Icons.lock_outline,
                            color: AppColors.highlight),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color: AppColors.highlight, width: 1.5)),
                      ),
                    ),
                    if (_error.isNotEmpty) ...[
                      SizedBox(height: 12),
                      Text(_error,
                          style:
                              TextStyle(color: AppColors.error, fontSize: 13)),
                    ],
                    SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.highlight,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: AppColors.white, strokeWidth: 2.5)
                            : Text('UPDATE PASSWORD',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
