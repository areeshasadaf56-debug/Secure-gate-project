import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/app_colors.dart';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isAdmin;
  const OtpScreen({super.key, required this.email, this.isAdmin = false});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _isSending = true;
  bool _isVerified = false;
  String _error = '';
  int _resendTimer = 30;
  bool _canResend = false;
  late String _generatedOtp;

  // ✅ EmailJS Keys
  final String _serviceId = 'service_u5746df';
  final String _templateId = 'template_hvqiyl8';
  final String _publicKey = 'IhD8_nM53_4ZWIoaF';

  @override
  void initState() {
    super.initState();
    _generatedOtp = _generateOtp();
    _sendOtpEmail();
    _startTimer();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> _sendOtpEmail() async {
    setState(() {
      _isSending = true;
      _error = '';
    });
    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'to_email': widget.email,
            'to_name': widget.email.split('@')[0],
            'otp_code': _generatedOtp,
          },
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('✅ OTP sent to ${widget.email} — check inbox & spam!'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        setState(() {
          _isSending = false;
          _error = 'Failed to send OTP (${response.statusCode}). Try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _error = 'Network error. Could not send OTP.';
      });
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
        }
      });
      return _resendTimer > 0;
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) _focusNodes[index + 1].requestFocus();
    if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length < 6) {
      setState(() => _error = 'Please enter all 6 digits');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = '';
    });
    await Future.delayed(const Duration(seconds: 1));

    if (_enteredOtp == _generatedOtp) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              widget.isAdmin ? const AdminDashboard() : const UserDashboard(),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Wrong OTP! Check your email.';
        for (var c in _controllers) {
          c.clear();
        }
      });
      _focusNodes[0].requestFocus();
    }
  }

  void _resendOtp() {
    setState(() {
      _canResend = false;
      _resendTimer = 30;
      _error = '';
      _generatedOtp = _generateOtp();
      for (var c in _controllers) {
        c.clear();
      }
    });
    _startTimer();
    _sendOtpEmail();
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
            colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.highlight.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.highlight, width: 2),
                ),
                child: const Icon(Icons.lock_clock,
                    size: 45, color: AppColors.highlight),
              ),

              const SizedBox(height: 24),

              const Text('OTP Verification',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Sending Status
              if (_isSending)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.highlight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.highlight.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              color: AppColors.highlight, strokeWidth: 2)),
                      SizedBox(width: 12),
                      Text('Sending OTP to your email...',
                          style: TextStyle(color: AppColors.highlight)),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.mark_email_read,
                          color: AppColors.success, size: 28),
                      const SizedBox(height: 8),
                      const Text('OTP sent to',
                          style: TextStyle(
                              color: AppColors.greyText, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(widget.email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AppColors.highlight,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('Check inbox & spam folder 📧',
                          style: TextStyle(
                              color: AppColors.greyText, fontSize: 12)),
                    ],
                  ),
                ),

              // Admin Badge
              if (widget.isAdmin) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: const Text('🛡️ Admin Access',
                      style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],

              const SizedBox(height: 36),

              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 46,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.highlight, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color:
                                    AppColors.highlight.withValues(alpha: 0.3),
                                width: 1)),
                      ),
                      onChanged: (val) => _onOtpChanged(val, index),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Error
              if (_error.isNotEmpty)
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
                          child: Text(_error,
                              style: const TextStyle(
                                  color: AppColors.error, fontSize: 13))),
                    ],
                  ),
                ),

              // Success
              if (_isVerified)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success),
                      SizedBox(width: 8),
                      Text('✅ Verified! Redirecting...',
                          style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

              const SizedBox(height: 28),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (_isLoading || _isVerified || _isSending)
                      ? null
                      : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlight,
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
                                    color: AppColors.white, strokeWidth: 2.5)),
                            SizedBox(width: 12),
                            Text('Verifying...',
                                style: TextStyle(color: AppColors.white)),
                          ],
                        )
                      : const Text('VERIFY OTP',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2)),
                ),
              ),

              const SizedBox(height: 20),

              // Resend
              GestureDetector(
                onTap: _canResend ? _resendOtp : null,
                child: RichText(
                  text: TextSpan(
                    text: 'Resend OTP ',
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 14),
                    children: [
                      TextSpan(
                        text: _canResend ? 'Resend Now' : 'in ${_resendTimer}s',
                        style: TextStyle(
                          color: _canResend
                              ? AppColors.highlight
                              : AppColors.greyText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
