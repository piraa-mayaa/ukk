import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Bagian Logo Atas
          _buildHeader(),
          const SizedBox(height: 20),
          // Daftar Menu
          _buildMenuItem(Icons.grid_view_rounded, "Dashboard"),
          _buildMenuItem(Icons.inventory_2_outlined, "Data alat"),
          _buildMenuItem(Icons.category_outlined, "Kategori"),
          _buildMenuItem(Icons.person_outline, "Data user"),
          _buildMenuItem(Icons.assignment_outlined, "Peminjaman", isActive: true),
          _buildMenuItem(Icons.assignment_return_outlined, "Pengembalian"),
          _buildMenuItem(Icons.history, "Log Aktivitas"),
          const Spacer(),
          // Tombol Keluar
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: const Color(0xFF1A237E),
            child: const Icon(Icons.handyman, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 10),
          const Text("PEDULI ARSIP ALAT", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("TEKNIK PEMBANGKIT", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFDBB2D) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? Colors.white : Colors.black54),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDBB2D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.logout, size: 16, color: Colors.white),
          label: const Text("Keluar", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}