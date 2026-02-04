import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF9D59B),
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0; // 0 = Dashboard

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedRole = 'Admin';

  final List<Map<String, dynamic>> _loanData = [
    {'nama': 'Andi Saputra', 'alat': 'Oscilloscope', 'tgl': '24 April 2024', 'status': 'Dipinjam'},
    {'nama': 'Budi Santoso', 'alat': 'Multimeter', 'tgl': '23 April 2024', 'status': 'Dipinjam'},
    {'nama': 'Deni Pratama', 'alat': 'Tang Amper', 'tgl': '23 April 2024', 'status': 'Menunggu'},
    {'nama': 'Citra Lestari', 'alat': 'Compressor Mini', 'tgl': '22 April 2024', 'status': 'Dipinjam'},
    {'nama': 'Eka Putri', 'alat': 'Pressure Gauge', 'tgl': '22 April 2024', 'status': 'Dipinjam'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLoans {
    if (_searchQuery.isEmpty) return _loanData;
    return _loanData.where((loan) {
      return loan['nama'].toLowerCase().contains(_searchQuery) ||
             loan['alat'].toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void _showTambahPeminjamanBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF8E1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tambah Peminjaman',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Peminjam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Masukkan nama peminjam',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Nama Alat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Masukkan nama alat',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tgl Pinjam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Pilih tanggal pinjam')),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Pilih tanggal', style: TextStyle(color: Colors.grey)),
                                          const Icon(Icons.calendar_today, color: Color(0xFFFF9800)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: 'Dipinjam', child: Text('Dipinjam')),
                                      DropdownMenuItem(value: 'Menunggu', child: Text('Menunggu')),
                                      DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                                      DropdownMenuItem(value: 'Dikembalikan', child: Text('Dikembalikan')),
                                    ],
                                    onChanged: (value) {},
                                    hint: const Text('Pilih status'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Peminjaman berhasil disimpan')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9800),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Simpan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onMenuTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Tutup drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Column(
        children: [
          // Header - selalu muncul di semua halaman
          Container(
            color: const Color(0xFFF9D59B),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderLogo(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notifications, color: Colors.white),
                            const SizedBox(width: 16),
                            DropdownButton<String>(
                              value: _selectedRole,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                                DropdownMenuItem(value: 'Petugas', child: Text('Petugas')),
                                DropdownMenuItem(value: 'Peminjam', child: Text('Peminjam')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedRole = val);
                              },
                              dropdownColor: Colors.white,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.waving_hand, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Selamat datang, $_selectedRole',
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Konten utama dengan IndexedStack
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                // 0: Dashboard - lengkap dengan search + tombol + + statistik + list
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToAlatList('Tersedia'),
                            child: _statCard(Icons.check_circle_outline, '58', 'Alat tersedia', const Color(0xFF2ECC71)),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToAlatList('Sedang dipinjam'),
                            child: _statCard(Icons.sync, '4', 'Sedang dipinjam', const Color(0xFFF39C12)),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToAlatList('Alat rusak'),
                            child: _statCard(Icons.handyman_outlined, '5', 'Alat rusak', const Color(0xFFE74C3C)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Cari',
                                prefixIcon: const Icon(Icons.search, size: 22),
                                filled: true,
                                fillColor: const Color(0xFFFDE6B0).withOpacity(0.4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _showTambahPeminjamanBottomSheet,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9D59B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.add, color: Colors.orange, size: 24),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Peminjaman Terbaru',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      if (_filteredLoans.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Tidak ada data yang ditemukan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ..._filteredLoans.map((loan) => _loanCard(
                              loan['nama'],
                              loan['alat'],
                              loan['tgl'],
                              loan['status'],
                            )),
                    ],
                  ),
                ),

                // 1: Data Alat - langsung ke AlatListScreen dengan kategori default
                const AlatListScreen(category: 'Semua'),

                // 2: Kategori - placeholder (ganti dengan KategoriListPage nanti)
                const Center(child: Text('Halaman Kategori', style: TextStyle(fontSize: 24))),

                // 3: Data User
                const Center(child: Text('Halaman Data User', style: TextStyle(fontSize: 24))),

                // 4: Peminjaman
                const Center(child: Text('Halaman Peminjaman', style: TextStyle(fontSize: 24))),

                // 5: Pengembalian
                const Center(child: Text('Halaman Pengembalian', style: TextStyle(fontSize: 24))),

                // 6: Log Aktivitas
                const Center(child: Text('Halaman Log Aktivitas', style: TextStyle(fontSize: 24))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi card statistik
  Widget _statCard(IconData icon, String number, String label, Color color) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              Text(
                number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Fungsi card peminjaman
  Widget _loanCard(String nama, String alat, String tgl, String status) {
    final statusColor = status == 'Dipinjam' ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Peminjam : $nama'),
                Text('Nama Alat : $alat'),
                Text('Tanggal pinjam : $tgl'),
                Row(
                  children: [
                    const Text('Status : ', style: TextStyle(fontSize: 11, color: Colors.black54)),
                    Text(
                      status,
                      style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              TextButton(onPressed: () {}, child: const Text('Edit')),
              TextButton(
                onPressed: () {},
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAlatList(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlatListScreen(category: category),
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFF001F3F),
          child: Icon(Icons.settings_input_component, color: Colors.orange, size: 28),
        ),
        const SizedBox(height: 8),
        const Text(
          "PEMINJAMAN ALAT",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const Text(
          "Teknik Pembangkit",
          style: TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }

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
                Text(
                  "PEMINJAMAN ALAT",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerTile(Icons.grid_view, 'Dashboard', _selectedIndex == 0, () => _onMenuTapped(0)),
                _DrawerTile(Icons.inventory_2_outlined, 'Data alat', _selectedIndex == 1, () => _onMenuTapped(1)),
                _DrawerTile(Icons.category_outlined, 'Kategori', _selectedIndex == 2, () => _onMenuTapped(2)),
                _DrawerTile(Icons.people_outline, 'Data user', _selectedIndex == 3, () => _onMenuTapped(3)),
                _DrawerTile(Icons.assignment_outlined, 'Peminjaman', _selectedIndex == 4, () => _onMenuTapped(4)),
                _DrawerTile(Icons.assignment_return_outlined, 'Pengembalian', _selectedIndex == 5, () => _onMenuTapped(5)),
                _DrawerTile(Icons.history, 'Log Aktivitas', _selectedIndex == 6, () => _onMenuTapped(6)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout berhasil')));
                },
                icon: const Icon(Icons.logout, color: Color(0xFF324E30)),
                label: const Text(
                  'Keluar',
                  style: TextStyle(color: Color(0xFF324E30), fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD180),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerTile(this.icon, this.title, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.orange : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.orange.withOpacity(0.1),
      onTap: onTap,
    );
  }
}

class AlatListScreen extends StatelessWidget {
  final String category;

  const AlatListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Halaman Data Alat',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Kategori: $category',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}