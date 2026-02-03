import 'package:flutter/material.dart';
import 'package:ukk/screens/auth/Dashboard/admin_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/peminjam_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/petugas_dashboard.dart';
import 'package:ukk/screens/auth/login_screen.dart';
import 'package:ukk/screens/auth/alat/alat_list_screen.dart';

class AppRoutes {
  // Route name constants
  static const login = '/login';
  static const admin = '/admin';
  static const petugas = '/petugas';
  static const peminjam = '/peminjam';
  static const dataAlat = '/data-alat';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    admin: (context) => AdminDashboard(),
    petugas: (context) => PetugasDashboard(),
    peminjam: (context) => PeminjamDashboard(),
    dataAlat: (context) => AlatList(),
  };
}
