import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/theme.dart';
import 'config/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'SUPABASE_URL',          // ganti dengan URL Supabase kamu
    anonKey: 'SUPABASE_ANON_KEY', // ganti dengan anon key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peminjaman Alat',
      theme: AppTheme.light,

      // ⬇️ PENTING: pakai STRING route agar TIDAK error
      initialRoute: '/login',
      routes: AppRoutes.routes,
    );
  }
}
