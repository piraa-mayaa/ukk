import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/theme.dart';
import 'config/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qrvxdlurbfywofsuhioo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFydnhkbHVyYmZ5d29mc3VoaW9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0NzMyNjMsImV4cCI6MjA3MzA0OTI2M30.TOaJipxULCD7b6A-NbnvgsSGUG9630_QXkhU1GSJv44',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peminjaman Alat',
      theme: AppTheme.light,

      // route awal (login)
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/theme.dart';
import 'config/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qrvxdlurbfywofsuhioo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFydnhkbHVyYmZ5d29mc3VoaW9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0NzMyNjMsImV4cCI6MjA3MzA0OTI2M30.TOaJipxULCD7b6A-NbnvgsSGUG9630_QXkhU1GSJv44',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peminjaman Alat',
      theme: AppTheme.light,

      // route awal (login)
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
