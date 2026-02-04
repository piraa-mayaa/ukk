import 'package:flutter/material.dart';
import 'package:ukk/screens/auth/splash_redirect.dart';
import 'package:ukk/screens/auth/login_screen.dart';
import 'package:ukk/screens/auth/Dashboard/admin_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/petugas_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/peminjam_dashboard.dart';
import 'package:ukk/screens/auth/alat/alat_list_screen.dart';

class AppRoutes {
  // ROUTE NAME
  static const String splash = '/';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String petugas = '/petugas';
  static const String peminjam = '/peminjam';
  static const String dataAlat = '/data-alat';

  // ROUTE MAP
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashRedirect(),
    login: (context) => const LoginScreen(),
    admin: (context) => const AdminDashboard(),
    petugas: (context) => const PetugasDashboard(),
    peminjam: (context) => const PeminjamDashboard(),
    dataAlat: (context) => const AlatListScreen(category: 'Semua'),
  };
}
