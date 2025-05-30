import 'package:flutter/material.dart';
import 'package:careerbrew/auth_service.dart';
import 'package:careerbrew/pages/HomePage.dart';
import './Onboarding /OnboardingPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool isLogin = true;
  String email = '';
  String password = '';

  void _goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyHomePage()),
    );
  }

  void _goToOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  Future<void> _checkProfileAndRedirect() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('UserData')
        .select('profile_complete')
        .eq('user_id', user.id)
        .maybeSingle();

    final isComplete = response?['profile_complete'] == true;

    if (isComplete) {
      _goToHomePage();
    } else {
      _goToOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Join Brew",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _buildToggleButton("Login", true),
                      _buildToggleButton("Sign Up", false),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isLogin
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: _buildLoginForm(),
                  secondChild: _buildSignUpForm(),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        const Text(
          "Welcome Back",
          style: TextStyle(fontSize: 24, color: Color(0xFF111827)),
        ),
        const SizedBox(height: 20),
        _emailField(),
        const SizedBox(height: 10),
        _passwordField(),
        const SizedBox(height: 20),
        _actionButton("Login"),
        const SizedBox(height: 20),
        _legalText(),
        const SizedBox(height: 20),
        _divider(),
        const SizedBox(height: 20),
        _authButtons(),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        const Text(
          "Create an Account",
          style: TextStyle(fontSize: 24, color: Color(0xFF111827)),
        ),
        const SizedBox(height: 20),
        _emailField(),
        const SizedBox(height: 10),
        _passwordField(),
        const SizedBox(height: 10),
        _passwordField(label: "Confirm Password"),
        const SizedBox(height: 20),
        _actionButton("Sign Up"),
        const SizedBox(height: 20),
        _legalText(),
        const SizedBox(height: 20),
        _divider(),
        const SizedBox(height: 20),
        _authButtons(),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool isCurrent) {
    final active = isLogin == isCurrent;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = isCurrent),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3B82F6) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF6B7280),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: _inputDecoration("Email"),
      style: const TextStyle(color: Color(0xFF111827)),
      onChanged: (value) => setState(() => email = value),
    );
  }

  Widget _passwordField({String label = "Password"}) {
    return TextField(
      obscureText: true,
      decoration: _inputDecoration(label),
      style: const TextStyle(color: Color(0xFF111827)),
      onChanged: (value) => setState(() => password = value),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      hintStyle: const TextStyle(color: Color(0xFF6B7280)),
      labelStyle: const TextStyle(color: Color(0xFF6B7280)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
      ),
    );
  }

  Widget _actionButton(String label) {
    return ElevatedButton(
      onPressed: () async {
        try {
          if (isLogin) {
            final res = await _authService.signInWithEmailPassword(email, password);
            if (res.user != null) {
              await _checkProfileAndRedirect();
            }
          } else {
            final res = await _authService.signUpWithEmailPassword(email, password);
            if (res.user != null) {
              _goToOnboarding();
            }
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFFB7185),
              content: Text("❌ Auth error: ${e.toString()}"),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size.fromHeight(50),
      ),
      child: Text(label),
    );
  }

  Widget _legalText() {
    return const Text(
      "By continuing, you agree to Brew's Terms of Service and Privacy Policy",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
    );
  }

  Widget _divider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: Color(0xFFD1D5DB))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("or", style: TextStyle(color: Color(0xFF6B7280))),
        ),
        Expanded(child: Divider(color: Color(0xFFD1D5DB))),
      ],
    );
  }

  Widget _authButtons() {
    return Column(
      children: [
        _buildAuthButton(
          icon: Icons.email,
          text: "Continue with Email",
          color: Colors.white,
          textColor: Color(0xFF111827),
        ),
        const SizedBox(height: 10),
        _buildAuthButton(
          icon: Icons.apple,
          text: "Sign in with Apple",
          color: Colors.black,
          textColor: Colors.white,
        ),
        const SizedBox(height: 10),
        _buildAuthButton(
          icon: Icons.g_mobiledata,
          text: "Sign in with Google",
          color: Color(0xFF3B82F6),
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildAuthButton({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size.fromHeight(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
