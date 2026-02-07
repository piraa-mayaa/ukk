import 'package:flutter/material.dart';
import 'package:ukk/screens/auth/splash_redirect.dart';
import 'package:ukk/screens/auth/login_screen.dart';
import 'package:ukk/screens/auth/Dashboard/admin_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/petugas_dashboard.dart';
import 'package:ukk/screens/auth/Dashboard/peminjam_dashboard.dart';
import 'package:ukk/screens/auth/alat/alat_list_screen.dart';
import 'package:ukk/screens/auth/kategori_list_screen.dart';
import 'package:ukk/screens/auth/data_user_screen.dart';
import 'package:ukk/screens/auth/alat/daftar_alat_peminjam.dart';
import 'package:ukk/screens/auth/keranjang_peminjaman.dart';
import 'package:ukk/screens/auth/peminjaman/riwayat_peminjaman_user.dart';
import 'package:ukk/screens/auth/peminjaman/persetujuan_peminjaman.dart';
import 'package:ukk/screens/auth/log_aktivitas_screen.dart';
import 'package:ukk/screens/auth/peminjaman/peminjaman_list_petugas.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String petugas = '/petugas';
  static const String peminjam = '/peminjam';
  static const String alatList = '/admin/alat';
  static const String kategoriList = '/admin/kategori';
  static const String userList = '/admin/user';
  static const String daftarAlat = '/peminjam/daftar-alat';
  static const String keranjang = '/keranjang';
  static const String riwayatPeminjaman = '/peminjam/riwayat';
  static const String persetujuanPeminjaman = '/petugas/persetujuan';
  static const String peminjamanListPetugas = '/petugas/peminjaman-list';
  static const String logAktivitas = '/log-aktivitas';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashRedirect(),
    login: (context) => const LoginScreen(),
    admin: (context) => const AdminDashboard(),
    petugas: (context) => const PetugasDashboard(),
    peminjam: (context) => const PeminjamDashboard(),
    alatList: (context) => const AlatList(),
    kategoriList: (context) => const KategoriListScreen(),
    userList: (context) => const DataUserScreen(),
    daftarAlat: (context) => const DaftarAlatPeminjam(),
    keranjang: (context) => const KeranjangPeminjaman(),
    riwayatPeminjaman: (context) =>
        const RiwayatPeminjamanUser(idUser: 1), // ID placeholder for now
    persetujuanPeminjaman: (context) => const PersetujuanPeminjaman(),
    peminjamanListPetugas: (context) => const PeminjamanListPetugas(),
    logAktivitas: (context) =>
        const Scaffold(body: SafeArea(child: LogAktivitasScreen())),
  };

  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToAdmin(BuildContext context) {
    Navigator.pushReplacementNamed(context, admin);
  }

  static void navigateToPetugas(BuildContext context) {
    Navigator.pushReplacementNamed(context, petugas);
  }

  static void navigateToPeminjam(BuildContext context) {
    Navigator.pushReplacementNamed(context, peminjam);
  }

  static void navigateToAlatList(BuildContext context) {
    Navigator.pushNamed(context, alatList);
  }

  static void navigateToKategoriList(BuildContext context) {
    Navigator.pushNamed(context, kategoriList);
  }

  static void navigateToUserList(BuildContext context) {
    Navigator.pushNamed(context, userList);
  }

  static void navigateToDaftarAlat(BuildContext context) {
    Navigator.pushNamed(context, daftarAlat);
  }

  static void navigateToKeranjang(BuildContext context) {
    Navigator.pushNamed(context, keranjang);
  }

  static void navigateToRiwayatPeminjaman(BuildContext context) {
    Navigator.pushNamed(context, riwayatPeminjaman);
  }

  static void navigateToPersetujuanPeminjaman(BuildContext context) {
    Navigator.pushNamed(context, persetujuanPeminjaman);
  }
}
