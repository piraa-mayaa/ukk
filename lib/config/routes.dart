import 'package:flutter/material.dart';
import 'package:ukk/screens/auth/Dashboard/admin_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/peminjam_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/petugas_dashboard.dart';
import 'package:ukk/screens/auth/login_screen.dart';
import 'package:ukk/screens/auth/alat/alat_list_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginScreen(),
    '/admin': (context) => const AdminDashboard(),
    '/petugas': (context) => const PetugasDashboard(),
    '/peminjam': (context) => const PeminjamDashboard(),
    '/data-alat': (context) => const AlatList(),
  };
}
