import 'package:flutter/material.dart';
import 'package:target_3/screens/auth/Dashboard/admin_dashboard.dart';
import 'package:target_3/screens/auth/Dashboard/peminjam_dashboard.dart';
import 'package:target_3/screens/auth/Dashboard/petugas_dashboard.dart';
import '../screens/auth/login_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (_) => const LoginScreen(),
    '/admin': (_) => const AdminDashboard(),
    '/petugas': (_) => const PetugasDashboard(),
    '/peminjam': (_) => const PeminjamDashboard(),
  };
}
