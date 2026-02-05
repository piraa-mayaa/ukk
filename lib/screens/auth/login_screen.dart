import 'package:flutter/material.dart';
import 'package:ukk/services/supabase_service.dart';
import 'package:ukk/config/routes.dart';

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
        usernameCtrl.text.trim(), passwordCtrl.text);

    setState(() => _loading = false);

    if (user != null) {
      // Navigate based on role
      if (user.role == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.admin);
      } else if (user.role == 'petugas') {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),

            // ================= LOGO GAMBAR =================
            Container(
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
            ),

            const SizedBox(height: 40),

            // ================= CARD LOGIN =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Silahkan\nisi dulu, baru masuk!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Username:'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: usernameCtrl,
                      hint: 'Masukkan Username',
                    ),
                    const SizedBox(height: 16),
                    const Text('Password:'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: passwordCtrl,
                      hint: 'Masukkan Password',
                      obscure: true,
                    ),
                    if (showError)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          'Password salah',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(160, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Text('Masuk'),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
