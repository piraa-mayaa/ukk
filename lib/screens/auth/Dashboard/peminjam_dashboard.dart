import 'package:flutter/material.dart';
import '../../../widgets/responsive_layout.dart';
import '../../../config/routes.dart';
import '../../../services/service_alat.dart';
import '../../../services/service_kategori.dart';
import '../../../models/kategori_model.dart';

class PeminjamDashboard extends StatefulWidget {
  const PeminjamDashboard({super.key});

  @override
  State<PeminjamDashboard> createState() => _PeminjamDashboardState();
}

class _PeminjamDashboardState extends State<PeminjamDashboard> {
  String _selectedRole = 'Peminjam';

  final ServiceAlat _serviceAlat = ServiceAlat();
  final ServiceKategori _serviceKategori = ServiceKategori();

  Map<String, int> _stats = {
    'tersedia': 0,
    'dipinjam': 0,
    'rusak': 0,
  };

  List<KategoriModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final alats = await _serviceAlat.getAlats();
    final categories = await _serviceKategori.getAllKategori();

    if (mounted) {
      setState(() {
        _stats = {
          'tersedia': alats.where((a) => a.status == 'tersedia').length,
          'dipinjam': alats.where((a) => a.status == 'dipinjam').length,
          'rusak': alats.where((a) => a.kondisi == 'rusak').length,
        };
        _categories = categories;
        _isLoading = false;
      });
    }
  }

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
              // ── Header ────────────────────────────────
              Container(
                color: const Color(0xFFF9D59B),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Responsive(
                  mobile: _buildHeaderMobile(),
                  desktop: _buildHeaderDesktop(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PEMINJAMAN ALAT',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Teknik Pembangkit',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Dashboard',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Responsive(
                      mobile: _buildStatRows(),
                      desktop: _buildStatRowsDesktop(),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Kategori Alat',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_categories.isEmpty)
                      const Text('Belum ada kategori')
                    else
                      Responsive(
                        mobile: Column(
                          children: _categories
                              .map((category) =>
                                  _buildCategoryCard(context, category.nama))
                              .toList(),
                        ),
                        desktop: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 3.5,
                          ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryCard(
                                context, _categories[index].nama);
                          },
                        ),
                      ),
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
                child: const Icon(Icons.build_circle,
                    color: Colors.orange, size: 60),
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
            onTap: () {
              Navigator.pop(context);
              AppRoutes.navigateToRiwayatPeminjaman(context);
            },
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
                onPressed: () {
                  Navigator.pop(context);
                  AppRoutes.navigateToLogin(context);
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCB7D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
        color: isSelected
            ? const Color(0xFFE6A34E)
            : Colors.white.withOpacity(0.5),
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
  Widget _buildHeaderMobile() {
    return Column(
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF001F3F),
              child: Icon(Icons.settings_input_component,
                  color: Colors.orange, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PEMINJAMAN ALAT",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Teknik Pembangkit",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            _buildRoleDropdown(),
          ],
        ),
        const SizedBox(height: 16),
        _buildGreetingBubble(),
      ],
    );
  }

  Widget _buildHeaderDesktop() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon:
                        const Icon(Icons.menu, color: Colors.black87, size: 30),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 20),
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFF001F3F),
                  child: Icon(Icons.settings_input_component,
                      color: Colors.orange, size: 35),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PEMINJAMAN ALAT",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      "Teknik Pembangkit - Sistem Inventaris Alat",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.waving_hand,
                          color: Colors.black54, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Halo, Selamat Beraktivitas!',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                _buildRoleDropdown(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildStatRowsDesktop() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.check_circle,
          value: _stats['tersedia']!,
          label: 'Alat tersedia',
          color: Colors.green,
        ),
        _buildStatCard(
          icon: Icons.autorenew,
          value: _stats['dipinjam']!,
          label: 'Sedang dipinjam',
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.dangerous,
          value: _stats['rusak']!,
          label: 'Alat rusak',
          color: Colors.red,
        ),
      ],
    );
  }

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
          value: _stats['tersedia']!,
          label: 'Alat tersedia',
          color: Colors.green,
        ),
        _buildStatCard(
          icon: Icons.autorenew,
          value: _stats['dipinjam']!,
          label: 'Sedang dipinjam',
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.dangerous,
          value: _stats['rusak']!,
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          title: Text(
            category,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          onTap: () {
            AppRoutes.navigateToDaftarAlat(context);
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
