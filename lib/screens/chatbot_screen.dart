import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'bot',
      'text': 'Hi! I am Secure Gate Assistant 🔐 How can I help you?'
    },
  ];
  bool _isTyping = false;

  final Map<String, String> _responses = {
    'forgot password':
        'Go to Login screen → tap "Forgot Password" → enter your email → check inbox!',
    'reset password':
        'Tap "Forgot Password" on the login screen. A reset link will be sent to your email.',
    'otp':
        'OTP is a One Time Password. It is a 6-digit code sent to verify your identity.',
    'login':
        'Enter your email and password on the Login screen to access your account.',
    'register':
        'Tap "Register" on the login screen, fill your details and create your account!',
    'logout': 'Tap the logout icon on the top right of your dashboard.',
    'secure':
        'Secure Gate uses Firebase Authentication to keep your account safe!',
    'password':
        'Use a strong password with letters, numbers and symbols. Minimum 6 characters.',
    'help':
        'I can help with: login, register, forgot password, OTP, logout, security tips!',
    'hello': 'Hello! How can I assist you with Secure Gate today? 😊',
    'hi': 'Hi there! Ask me anything about Secure Gate 🔐',
  };

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(seconds: 1));

    String reply =
        'I am not sure about that. Try asking about: login, password, OTP, or logout!';
    for (final key in _responses.keys) {
      if (text.toLowerCase().contains(key)) {
        reply = _responses[key]!;
        break;
      }
    }

    setState(() {
      _isTyping = false;
      _messages.add({'sender': 'bot', 'text': reply});
    });
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
        title: const Row(
          children: [
            Icon(Icons.security, color: AppColors.highlight, size: 20),
            SizedBox(width: 8),
            Text('AI Assistant', style: TextStyle(color: AppColors.white)),
          ],
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return _typingBubble();
                  }
                  final msg = _messages[index];
                  final isUser = msg['sender'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.highlight.withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isUser
                              ? AppColors.highlight
                              : AppColors.highlight.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(msg['text']!,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 14)),
                    ),
                  );
                },
              ),
            ),

            // Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border(
                    top: BorderSide(
                        color: AppColors.highlight.withValues(alpha: 0.2))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        hintText: 'Ask something...',
                        hintStyle: const TextStyle(color: AppColors.greyText),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: AppColors.highlight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send,
                          color: AppColors.white, size: 20),
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

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.highlight.withValues(alpha: 0.2)),
        ),
        child: const Text('Typing...',
            style: TextStyle(color: AppColors.greyText, fontSize: 14)),
      ),
    );
  }
}
