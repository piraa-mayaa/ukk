import 'package:flutter/material.dart';
import 'package:ukk/config/routes.dart';
import 'package:ukk/services/supabase_config.dart';

class SplashRedirect extends StatefulWidget {
  const SplashRedirect({super.key});

  @override
  State<SplashRedirect> createState() => _SplashRedirectState();
}

class _SplashRedirectState extends State<SplashRedirect> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = SupabaseConfig.client.auth.currentSession;

      if (session == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.admin);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
