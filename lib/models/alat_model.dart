import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Model Alat sesuai file yang Anda berikan
class Alat {
  final String nama;
  final String kategori;
  final String status;

  Alat({
    required this.nama,
    required this.kategori,
    required this.status,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9D59B), // Warna latar header
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Header: Logo & Profil Admin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const HeaderLogo(),
                const AdminBadge(),
              ],
            ),
          ),
          const SizedBox(height: 25),
          // Konten Putih Melengkung
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    // Row Kartu Ringkasan
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SummaryCard(
                          label: "Alat tersedia",
                          count: "58",
                          color: Color(0xFF2ECC71),
                          icon: Icons.check_circle,
                        ),
                        SummaryCard(
                          label: "Sedang dipinjam",
                          count: "4",
                          color: Color(0xFFF39C12),
                          icon: Icons.sync,
                        ),
                        SummaryCard(
                          label: "Alat rusak",
                          count: "5",
                          color: Color(0xFFE74C3C),
                          icon: Icons.gavel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Bar Pencarian
                    const SearchBarSection(),
                    const SizedBox(height: 25),
                    // Section Peminjaman Terbaru
                    const RecentLoansSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Komponen Pendukung UI ---

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            width: double.infinity,
            color: const Color(0xFFF9D59B),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xFF001F3F),
                  child: Icon(Icons.settings_input_component, color: Colors.orange, size: 40),
                ),
                SizedBox(height: 15),
                Text("PEMINJAMAN ALAT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _drawerItem(Icons.dashboard, "Dashboard", true),
                _drawerItem(Icons.assignment, "Data alat", false),
                _drawerItem(Icons.category, "Kategori", false),
                _drawerItem(Icons.people, "Data user", false),
                _drawerItem(Icons.event_note, "Peminjaman", false),
                _drawerItem(Icons.assignment_return, "Pengembalian", false),
                _drawerItem(Icons.history, "Log Aktifitas", false),
              ],
            ),
          ),
          // Tombol Keluar dengan warna ikon #324E30 sesuai permintaan
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Color(0xFF324E30)), // Warna yang Anda minta
                label: const Text(
                  "Keluar",
                  style: TextStyle(color: Color(0xFF324E30), fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD180),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, bool selected) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(color: selected ? Colors.orange : Colors.black87, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      onTap: () {},
    );
  }
}

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFF001F3F),
          child: Icon(Icons.settings_input_component, color: Colors.orange, size: 30),
        ),
        SizedBox(height: 10),
        Text("PEMINJAMAN ALAT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text("Teknik Pembangkit", style: TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }
}

class AdminBadge extends StatelessWidget {
  const AdminBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Selamat datang,", style: TextStyle(fontSize: 8)),
              Text("Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label, count;
  final Color color;
  final IconData icon;

  const SummaryCard({required this.label, required this.count, required this.color, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              Text(count, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 8), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 20),
              hintText: "Cari",
              filled: true,
              fillColor: const Color(0xFFFDE6B0).withOpacity(0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF9D59B), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.add, color: Colors.orange),
        ),
      ],
    );
  }
}

class RecentLoansSection extends StatelessWidget {
  const RecentLoansSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Peminjaman Terbaru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 15),
          _loanItem("Andi Saputra", "Oscilloscope", "24 April 2024", "Dipinjam", Colors.green),
          _loanItem("Budi Santoso", "Multimeter", "23 April 2024", "Dipinjam", Colors.green),
          _loanItem("Deni Pratama", "Tang Amper", "23 April 2024", "Menunggu", Colors.orange),
        ],
      ),
    );
  }

  Widget _loanItem(String name, String tool, String date, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Peminjam", name),
                _infoRow("Nama Alat", tool),
                _infoRow("Tanggal pinjam", date),
                Row(
                  children: [
                    const Text("Status : ", style: TextStyle(fontSize: 9, color: Colors.grey)),
                    Text(status, style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _actionButton("Setujui", const Color(0xFFA5D6A7)),
              const SizedBox(width: 5),
              _actionButton("Tolak", const Color(0xFFEF9A9A)),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text("$label : ", style: const TextStyle(fontSize: 9, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}