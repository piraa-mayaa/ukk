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
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9D59B), // Warna header (Kuning)
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderLogo(),
                _buildAdminBadge(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // ================= AREA KONTEN PUTIH (LENGKUNG) =================
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
                        _statCard(Icons.handyman_outlined, '5', 'Alat rusak', const Color(0xFFE74C3C)),
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
                              prefixIcon: const Icon(Icons.search, size: 22),
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

                    const SizedBox(height: 25),

                    // ================= LIST PEMINJAMAN TERBARU (5 DATA) =================
                    const Text(
                      'Peminjaman Terbaru',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),

                    _loanCard('Andi Saputra', 'Oscilloscope', '24 April 2024', 'Dipinjam', Colors.green),
                    _loanCard('Budi Santoso', 'Multimeter', '23 April 2024', 'Dipinjam', Colors.green),
                    _loanCard('Deni Pratama', 'Tang Amper', '23 April 2024', 'Menunggu', Colors.orange),
                    _loanCard('Citra Lestari', 'Compressor Mini', '22 April 2024', 'Dipinjam', Colors.green),
                    _loanCard('Eka Putri', 'Pressure Gauge', '22 April 2024', 'Dipinjam', Colors.green),
                    
                    const SizedBox(height: 20), // Memberi ruang di bawah agar tidak mentok
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
          backgroundColor: Color(0xFF001F3F), // Navy
          child: Icon(Icons.settings_input_component, color: Colors.orange, size: 28),
        ),
        const SizedBox(height: 8),
        const Text("PEMINJAMAN ALAT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const Text("Teknik Pembangkit", style: TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }

  // --- Widget Badge Admin ---
  Widget _buildAdminBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // --- Widget Loan Card ---
  Widget _loanCard(String nama, String alat, String tgl, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Warna background card abu-abu muda
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rowInfo('Peminjam', nama),
                _rowInfo('Nama Alat', alat),
                _rowInfo('Tanggal pinjam', tgl),
                Row(
                  children: [
                    const Text('Status : ', style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text(status, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _actionBtn('Setujui', const Color(0xFFA5D6A7)),
              const SizedBox(height: 6),
              _actionBtn('Tolak', const Color(0xFFEF9A9A)),
            ],
          )
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 10),
          children: [
            TextSpan(text: '$label : ', style: const TextStyle(color: Colors.black54)),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  // --- Widget Drawer ---
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            width: double.infinity,
            color: const Color(0xFFF9D59B),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF001F3F),
                  child: Icon(Icons.settings_input_component, color: Colors.orange, size: 40),
                ),
                SizedBox(height: 15),
                Text("PEMINJAMAN ALAT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          _drawerTile(Icons.grid_view, 'Dashboard', isSelected: true),
          _drawerTile(Icons.inventory_2_outlined, 'Data alat'),
          _drawerTile(Icons.category_outlined, 'Kategori'),
          _drawerTile(Icons.people_outline, 'Data user'),
          _drawerTile(Icons.assignment_outlined, 'Peminjaman'),
          _drawerTile(Icons.assignment_return_outlined, 'Pengembalian'),
          _drawerTile(Icons.history, 'Log Aktifitas'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Color(0xFF324E30)), 
                label: const Text('Keluar', style: TextStyle(color: Color(0xFF324E30), fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD180),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, {bool isSelected = false}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.orange : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      onTap: () {},
    );
  }
}1