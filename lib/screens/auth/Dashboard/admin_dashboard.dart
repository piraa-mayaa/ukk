import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sans-Serif'),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9D59B), // Warna kuning header
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Column(
        children: [
          // ================= HEADER: LOGO & PROFIL =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderLogo(),
                _buildAdminBadge(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // ================= AREA KONTEN PUTIH =================
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 15),

                    // ================= STAT CARDS =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statCard(Icons.check_circle_outline, '58', 'Alat tersedia', const Color(0xFF2ECC71)),
                        _statCard(Icons.sync, '4', 'Sedang dipinjam', const Color(0xFFF39C12)),
                        _statCard(Icons.gavel_rounded, '5', 'Alat rusak', const Color(0xFFE74C3C)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ================= SEARCH & ADD =================
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari',
                              prefixIcon: const Icon(Icons.search, size: 20),
                              filled: true,
                              fillColor: const Color(0xFFFDE6B0).withOpacity(0.4),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9D59B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add, color: Colors.orange),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ================= LIST PEMINJAMAN =================
                    const Text(
                      'Peminjaman Terbaru',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),

                    _loanCard('Andi Saputra', 'Oscilloscope', '24 April 2024', 'Dipinjam', Colors.green),
                    _loanCard('Budi Santoso', 'Multimeter', '23 April 2024', 'Dipinjam', Colors.green),
                    _loanCard('Deni Pratama', 'Tang Amper', '23 April 2024', 'Menunggu', Colors.orange),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Header Logo ---
  Widget _buildHeaderLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFF001F3F),
          child: Icon(Icons.settings_input_component, color: Colors.orange, size: 30),
        ),
        const SizedBox(height: 8),
        const Text("PEMINJAMAN ALAT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const Text("Teknik Pembangkit", style: TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }

  // --- Widget Profil Admin ---
  Widget _buildAdminBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              Text("Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  // --- Widget Stat Card ---
  Widget _statCard(IconData icon, String number, String label, Color color) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // --- Widget Kartu List ---
  Widget _loanCard(String nama, String alat, String tanggal, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoText('Peminjam', nama),
                _infoText('Nama Alat', alat),
                _infoText('Tanggal pinjam', tanggal),
                Row(
                  children: [
                    const Text('Status : ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(status, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _actionBtn('Setujui', const Color(0xFFA5D6A7)),
              const SizedBox(height: 4),
              _actionBtn('Tolak', const Color(0xFFEF9A9A)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text('$label : ', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _actionBtn(String text, Color color) {
    return Container(
      width: 60,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  // --- Widget Drawer ---
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            width: double.infinity,
            color: const Color(0xFFF9D59B),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF001F3F),
                  child: Icon(Icons.settings_input_component, color: Colors.orange, size: 40),
                ),
                SizedBox(height: 10),
                Text("PEMINJAMAN ALAT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.grid_view, color: Colors.orange), title: const Text('Dashboard', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)), onTap: () {}),
          _drawerItem(Icons.inventory_2_outlined, 'Data alat'),
          _drawerItem(Icons.category_outlined, 'Kategori'),
          _drawerItem(Icons.people_outline, 'Data user'),
          _drawerItem(Icons.assignment_outlined, 'Peminjaman'),
          _drawerItem(Icons.assignment_return_outlined, 'Pengembalian'),
          _drawerItem(Icons.history, 'Log Aktifitas'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {},
                // WARNA IKON SESUAI PERMINTAAN: #324E30
                icon: const Icon(Icons.logout, color: Color(0xFF324E30)),
                label: const Text('Keluar', style: TextStyle(color: Color(0xFF324E30), fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9D59B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      onTap: () {},
    );
  }
}