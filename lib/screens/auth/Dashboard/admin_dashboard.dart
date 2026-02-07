import 'package:flutter/material.dart';
import '../log_aktivitas_screen.dart';
import '../peminjaman/peminjaman_list_petugas.dart';
import '../../../config/routes.dart';
import '../../../services/service_alat.dart';
import '../../../services/service_peminjaman.dart';
import '../../../models/peminjaman_model.dart';
import '../../../widgets/responsive_layout.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final ServiceAlat _serviceAlat = ServiceAlat();
  final ServicePeminjaman _servicePeminjaman = ServicePeminjaman();

  Map<String, int> _stats = {
    'tersedia': 0,
    'dipinjam': 0,
    'rusak': 0,
  };

  List<PeminjamanModel> _recentLoans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final alats = await _serviceAlat.getAlats();
    final loans = await _servicePeminjaman.getAllPeminjaman();

    if (mounted) {
      setState(() {
        _stats = {
          'tersedia': alats.where((a) => a.status == 'tersedia').length,
          'dipinjam': alats.where((a) => a.status == 'dipinjam').length,
          'rusak': alats.where((a) => a.kondisi == 'rusak').length,
        };
        // Ambil 5 terbaru
        _recentLoans = loans.take(5).toList();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PeminjamanModel> get _filteredLoans {
    if (_searchQuery.isEmpty) return _recentLoans;
    return _recentLoans.where((loan) {
      final userNama = loan.user?.nama.toLowerCase() ?? '';
      return userNama.contains(_searchQuery);
    }).toList();
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
        backgroundColor: const Color(0xFFF9D59B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: const Color(0xFFF9D59B),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Responsive(
              mobile: _buildHeaderMobile(),
              desktop: _buildHeaderDesktop(),
            ),
          ),

          // Konten utama
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                // 0: Dashboard
                _buildDashboardContent(),
                // ... (rest of indexed stack remains same)

                // 1: Data Alat - placeholder
                const Center(
                  child: Text(
                    'Halaman Data Alat',
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                // 2: Kategori
                const Center(
                  child: Text(
                    'Halaman Kategori',
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                // 3: Data User
                const Center(
                  child: Text(
                    'Halaman Data User',
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                // 4. Peminjaman (Tab Index 0: Semua/Menunggu)
                const PeminjamanListPetugas(initialIndex: 0, isEmbedded: true),

                // 5. Pengembalian (Tab Index 1: Dipinjam/Disetujui)
                const PeminjamanListPetugas(initialIndex: 1, isEmbedded: true),

                // 6: Log Aktivitas
                const LogAktivitasScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Statistik Cards
          Responsive(
            mobile: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard(
                  Icons.check_circle_outline,
                  '${_stats['tersedia']}',
                  'Alat tersedia',
                  const Color(0xFF2ECC71),
                ),
                _statCard(
                  Icons.sync,
                  '${_stats['dipinjam']}',
                  'Sedang dipinjam',
                  const Color(0xFFF39C12),
                ),
                _statCard(
                  Icons.handyman_outlined,
                  '${_stats['rusak']}',
                  'Alat rusak',
                  const Color(0xFFE74C3C),
                ),
              ],
            ),
            tablet: Row(
              children: [
                _statCard(
                  Icons.check_circle_outline,
                  '${_stats['tersedia']}',
                  'Alat tersedia',
                  const Color(0xFF2ECC71),
                ),
                _statCard(
                  Icons.sync,
                  '${_stats['dipinjam']}',
                  'Sedang dipinjam',
                  const Color(0xFFF39C12),
                ),
                _statCard(
                  Icons.handyman_outlined,
                  '${_stats['rusak']}',
                  'Alat rusak',
                  const Color(0xFFE74C3C),
                ),
              ],
            ),
            desktop: Row(
              children: [
                _statCard(
                  Icons.check_circle_outline,
                  '${_stats['tersedia']}',
                  'Alat tersedia',
                  const Color(0xFF2ECC71),
                ),
                _statCard(
                  Icons.sync,
                  '${_stats['dipinjam']}',
                  'Sedang dipinjam',
                  const Color(0xFFF39C12),
                ),
                _statCard(
                  Icons.handyman_outlined,
                  '${_stats['rusak']}',
                  'Alat rusak',
                  const Color(0xFFE74C3C),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Quick Actions Menu
          const Text(
            'Menu Cepat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: Responsive.isMobile(context)
                ? 2
                : (Responsive.isTablet(context) ? 3 : 4),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: Responsive.isMobile(context) ? 1.5 : 1.2,
            children: [
              _quickMenuCard(
                context,
                icon: Icons.inventory_2,
                title: 'Data Alat',
                color: Colors.blue,
                onTap: () {
                  AppRoutes.navigateToAlatList(context);
                },
              ),
              _quickMenuCard(
                context,
                icon: Icons.category,
                title: 'Kategori',
                color: Colors.purple,
                onTap: () {
                  AppRoutes.navigateToKategoriList(context);
                },
              ),
              _quickMenuCard(
                context,
                icon: Icons.people,
                title: 'Data User',
                color: Colors.green,
                onTap: () {
                  AppRoutes.navigateToUserList(context);
                },
              ),
              _quickMenuCard(
                context,
                icon: Icons.assignment,
                title: 'Peminjaman',
                color: Colors.orange,
                onTap: () {
                  setState(() => _selectedIndex = 4);
                },
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari peminjaman...',
              prefixIcon: const Icon(Icons.search, size: 22),
              filled: true,
              fillColor: const Color(0xFFFDE6B0).withOpacity(0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Peminjaman Terbaru
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Peminjaman Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _selectedIndex = 4);
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_filteredLoans.isEmpty)
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
                  loan.user?.nama ?? 'User',
                  loan.details?.map((d) => d.alat?.nama).join(', ') ??
                      'No Alat',
                  loan.tanggalPinjam.toString().substring(0, 10),
                  loan.status,
                )),
        ],
      ),
    );
  }

  Widget _buildHeaderMobile() {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFF001F3F),
              child: Icon(
                Icons.settings_input_component,
                color: Colors.orange,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PEMINJAMAN ALAT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Teknik Pembangkit",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.waving_hand, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Selamat datang, Admin',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderDesktop() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFF001F3F),
                  child: Icon(
                    Icons.settings_input_component,
                    color: Colors.orange,
                    size: 35,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PEMINJAMAN ALAT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      "Teknik Pembangkit - Sistem Manajemen Alat",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.waving_hand, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Halo, Administrator Utama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String number, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
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
      ),
    );
  }

  Widget _quickMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loanCard(String nama, String alat, String tgl, String status) {
    final statusColor = status == 'Dipinjam' ? Colors.green : Colors.orange;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
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
                  Text(
                    'Peminjam : $nama',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Nama Alat : $alat',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Tanggal pinjam : $tgl',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Status : ',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
                  child: Icon(
                    Icons.settings_input_component,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "PEMINJAMAN ALAT",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Admin Dashboard",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerTile(
                  Icons.grid_view,
                  'Dashboard',
                  _selectedIndex == 0,
                  () => _onMenuTapped(0),
                ),
                _DrawerTile(
                  Icons.inventory_2_outlined,
                  'Data Alat',
                  _selectedIndex == 1,
                  () {
                    Navigator.pop(context);
                    AppRoutes.navigateToAlatList(context);
                  },
                ),
                _DrawerTile(
                  Icons.category_outlined,
                  'Kategori',
                  _selectedIndex == 2,
                  () {
                    Navigator.pop(context);
                    AppRoutes.navigateToKategoriList(context);
                  },
                ),
                _DrawerTile(
                  Icons.people_outline,
                  'Data User',
                  _selectedIndex == 3,
                  () {
                    Navigator.pop(context);
                    AppRoutes.navigateToUserList(context);
                  },
                ),
                _DrawerTile(
                  Icons.assignment_outlined,
                  'Peminjaman',
                  _selectedIndex == 4,
                  () => _onMenuTapped(4),
                ),
                _DrawerTile(
                  Icons.assignment_return_outlined,
                  'Pengembalian',
                  _selectedIndex == 5,
                  () => _onMenuTapped(5),
                ),
                _DrawerTile(
                  Icons.history,
                  'Log Aktivitas',
                  _selectedIndex == 6,
                  () => _onMenuTapped(6),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout, color: Color(0xFF324E30)),
                label: const Text(
                  'Keluar',
                  style: TextStyle(
                    color: Color(0xFF324E30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD180),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppRoutes.navigateToLogin(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
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
