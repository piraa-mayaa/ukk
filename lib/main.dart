import 'package:flutter/material.dart';
import 'services/supabase_config.dart';

import 'config/theme.dart';
import 'config/routes.dart';

Future<void> main() async {
  // Pastikan Flutter binding sudah siap sebelum Supabase init
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase dengan try-catch (penting untuk handle error)
  try {
    await SupabaseConfig.initialize();
    debugPrint('Supabase berhasil diinisialisasi');
  } catch (e, stack) {
    debugPrint('Gagal inisialisasi Supabase: $e');
    debugPrint('Stack trace: $stack');
    // Opsional: tampilkan error screen atau fallback ke halaman offline
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peminjaman Alat',

      // Tema
      theme: AppTheme.light,
      darkTheme: AppTheme.dark, // tambahkan jika sudah punya dark theme
      themeMode:
          ThemeMode.system, // mengikuti pengaturan sistem HP (light/dark)

      // Routes
      initialRoute: AppRoutes.login, // mulai dari login (bagus untuk auth)
      routes: AppRoutes.routes,

      // Mencegah text scaling berlebihan (accessibility)
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

// Helper global untuk akses Supabase client di mana saja
final supabase = SupabaseConfig.client;
