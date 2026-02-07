// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:ukk/services/supabase_service.dart';
import 'package:ukk/config/routes.dart';
import 'package:ukk/widgets/responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool showError = false;
  bool _loading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      showError = false;
    });

    final svc = SupabaseService();
    final user = await svc.loginWithUsersTable(
      usernameCtrl.text.trim(),
      passwordCtrl.text,
    );

    setState(() => _loading = false);

    if (user != null) {
      // Navigate based on role
      if (!mounted) return;

      final role = user.role.toLowerCase();
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.admin);
      } else if (role == 'petugas') {
        Navigator.pushReplacementNamed(context, AppRoutes.petugas);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.peminjam);
      }
    } else {
      setState(() => showError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC97C),
      body: Responsive(
        mobile: _buildMobileLogin(),
        tablet: _buildDesktopLogin(maxWidth: 500),
        desktop: _buildDesktopLogin(maxWidth: 600),
      ),
    );
  }

  Widget _buildMobileLogin() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 80),
          _buildLogo(),
          const SizedBox(height: 40),
          _buildLoginCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDesktopLogin({required double maxWidth}) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 40),
              _buildLoginCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Silahkan\nisi dulu, baru masuk!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Username:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _inputField(
              controller: usernameCtrl,
              hint: 'Masukkan Username',
            ),
            const SizedBox(height: 20),
            const Text(
              'Password:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _inputField(
              controller: passwordCtrl,
              hint: 'Masukkan Password',
              obscure: true,
            ),
            if (showError)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Username atau password salah',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _loading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
