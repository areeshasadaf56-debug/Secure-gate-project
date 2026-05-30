import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _saved = false;
  String _error = '';

  String _selectedAvatar = '👤';
  final List<String> _avatars = [
    '👤',
    '👨',
    '👩',
    '🧑',
    '👨‍💻',
    '👩‍💻',
    '🧑‍💼',
    '👨‍🎓',
    '👩‍🎓',
    '🦸',
    '🧙'
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? '';
  }

  Future<void> _refreshUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.reload();
    setState(() {}); // IMPORTANT: rebuild so emailVerified updates
  }

  Future<void> _sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _error = '';
      _saved = false;
    });

    try {
      await user.sendEmailVerification();
      setState(() {
        _saved = true;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to send verification email. Please try again.';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = 'Name cannot be empty');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
      _saved = false;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _error = 'Not logged in!';
        });
        return;
      }

      await user.updateDisplayName(_nameController.text.trim());
      await user.reload();

      setState(() {
        _isLoading = false;
        _saved = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Update failed. Logout and login again, then try.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.highlight),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('My Profile', style: TextStyle(color: AppColors.white)),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.highlight.withValues(alpha: 0.15),
                        border:
                            Border.all(color: AppColors.highlight, width: 2),
                      ),
                      child: Center(
                        child: Text(_selectedAvatar,
                            style: const TextStyle(fontSize: 50)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Pick your avatar',
                        style:
                            TextStyle(color: AppColors.greyText, fontSize: 12)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 52,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _avatars.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedAvatar = _avatars[i]),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selectedAvatar == _avatars[i]
                                    ? AppColors.highlight.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _selectedAvatar == _avatars[i]
                                      ? AppColors.highlight
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Text(_avatars[i],
                                  style: const TextStyle(fontSize: 26)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Info Cards
              _infoCard(Icons.email_outlined, 'Email', user?.email ?? 'N/A'),
              const SizedBox(height: 12),
              _infoCard(
                Icons.verified_user,
                'Email Verified',
                user?.emailVerified == true ? '✅ Verified' : '❌ Not Verified',
              ),

              // Buttons for verification (only show if not verified)
              if (user != null && user.emailVerified == false) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _sendVerificationEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlight,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('SEND VERIFICATION EMAIL'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _refreshUser,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: BorderSide(
                          color: AppColors.highlight.withValues(alpha: 0.9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('I VERIFIED — REFRESH STATUS'),
                  ),
                ),
              ],

              const SizedBox(height: 12),
              _infoCard(
                Icons.calendar_today,
                'Member Since',
                user?.metadata.creationTime?.toString().split(' ')[0] ?? 'N/A',
              ),
              const SizedBox(height: 12),
              _infoCard(
                Icons.access_time,
                'Last Login',
                user?.metadata.lastSignInTime?.toString().split(' ')[0] ??
                    'N/A',
              ),
              const SizedBox(height: 12),
              _infoCard(Icons.shield, 'Account Role', 'User'),
              const SizedBox(height: 12),
              _infoCard(Icons.fingerprint, 'User ID',
                  user?.uid.substring(0, 10) ?? 'N/A'),

              const SizedBox(height: 30),

              // Edit Name
              TextField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  labelStyle: const TextStyle(color: AppColors.greyText),
                  prefixIcon: const Icon(Icons.person_outline,
                      color: AppColors.highlight),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.highlight, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Phone
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  labelText: 'Phone Number (optional)',
                  labelStyle: const TextStyle(color: AppColors.greyText),
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: AppColors.highlight),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.highlight, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 16),

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
                                color: AppColors.error, fontSize: 13)),
                      ),
                    ],
                  ),
                ),

              if (_saved)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 18),
                      SizedBox(width: 8),
                      Text('Done ✅',
                          style: TextStyle(color: AppColors.success)),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
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
                                color: AppColors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Updating...',
                                style: TextStyle(color: AppColors.white)),
                          ],
                        )
                      : const Text(
                          'UPDATE PROFILE',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
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

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.highlight, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 11)),
                Text(value,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
