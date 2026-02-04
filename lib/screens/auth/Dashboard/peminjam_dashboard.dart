import 'package:flutter/material.dart';

class PeminjamDashboard extends StatefulWidget {
  const PeminjamDashboard({super.key});

  @override
  State<PeminjamDashboard> createState() => _PeminjamDashboardState();
}

class _PeminjamDashboardState extends State<PeminjamDashboard> {
  String _selectedRole = 'Peminjam';

  // Statistik alat
  final Map<String, int> stats = {
    'tersedia': 58,
    'dipinjam': 4,
    'rusak': 5,
  };

  // Kategori alat
  final List<String> categories = [
    'Alat Ukur',
    'Alat Listrik',
    'Alat Kontrol',
    'Alat Mesin',
    'Alat Pendukung',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      // --- PENAMBAHAN DRAWER ---
      drawer: _buildDrawer(context), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: const Color(0xFFFF9800),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Ikon Menu Garis Tiga untuk membuka Drawer
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Logo Aplikasi
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.build_circle, color: Color(0xFFFF9800), size: 32),
                        ),
                        const SizedBox(width: 12),
                        // Judul
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PEMINJAMAN ALAT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Teknik Pembangkit',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.notifications, color: Colors.white),
                        const SizedBox(width: 16),
                        _buildRoleDropdown(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildGreetingBubble(),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PEMINJAMAN ALAT',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Teknik Pembangkit',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    _buildStatRows(),
                    const SizedBox(height: 32),
                    const Text(
                      'Kategori Alat',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ...categories.map((category) => _buildCategoryCard(context, category)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET DRAWER (MENU SAMPING) ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFE3B3), // Warna krem sesuai desain
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF1A3D6B), // Biru logo
                child: const Icon(Icons.build_circle, color: Colors.orange, size: 60),
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.grid_view_rounded,
            label: "Dashboard",
            isSelected: true,
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.fact_check_outlined,
            label: "Peminjaman",
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.archive_outlined,
            label: "Pengembalian",
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.history,
            label: "Log Aktifitas",
            onTap: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, size: 18),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCB7D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE6A34E) : Colors.white.withOpacity(0.5),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildRoleDropdown() {
    return DropdownButton<String>(
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
    );
  }

  Widget _buildGreetingBubble() {
    return Container(
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
    );
  }

  Widget _buildStatRows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(
          icon: Icons.check_circle,
          value: stats['tersedia']!,
          label: 'Alat tersedia',
          color: Colors.green,
        ),
        _buildStatCard(
          icon: Icons.autorenew,
          value: stats['dipinjam']!,
          label: 'Sedang dipinjam',
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.dangerous,
          value: stats['rusak']!,
          label: 'Alat rusak',
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          title: Text(
            category,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Membuka kategori $category')),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color.withOpacity(0.9), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}