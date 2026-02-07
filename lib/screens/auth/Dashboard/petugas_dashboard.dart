import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/routes.dart';
import '../../../services/service_alat.dart';
import '../../../services/service_peminjaman.dart';
import '../../../models/peminjaman_model.dart';
import '../../../widgets/responsive_layout.dart';
import '../log_aktivitas_screen.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  String _selectedRole = 'Petugas';

  final ServiceAlat _serviceAlat = ServiceAlat();
  final ServicePeminjaman _servicePeminjaman = ServicePeminjaman();

  Map<String, int> _stats = {
    'tersedia': 0,
    'dipinjam': 0,
    'rusak': 0,
  };

  List<PeminjamanModel> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final alats = await _serviceAlat.getAlats();
    final loans = await _servicePeminjaman.getPeminjamanByStatus('menunggu');

    if (mounted) {
      setState(() {
        _stats = {
          'tersedia': alats.where((a) => a.status == 'tersedia').length,
          'dipinjam': alats.where((a) => a.status == 'dipinjam').length,
          'rusak': alats.where((a) => a.kondisi == 'rusak').length,
        };
        _pendingRequests = loans;
        _isLoading = false;
      });
    }
  }

  // Form fields
  final _namaSiswaController = TextEditingController();
  final _namaAlatController = TextEditingController();
  String? _selectedKelas;
  TimeOfDay? _jamMulai;
  TimeOfDay? _jamSelesai;

  Future<void> _pickTime(bool isMulai) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        if (isMulai) _jamMulai = picked;
        if (!isMulai) _jamSelesai = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // cream/orange muda
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────
              Container(
                color: const Color(0xFFFF9800),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                    // Statistik
                    Responsive(
                      mobile: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard(
                            icon: Icons.check_circle_outline,
                            label: 'Tersedia',
                            value: _stats['tersedia']!,
                            color: Colors.green,
                          ),
                          _buildStatCard(
                            icon: Icons.swap_horiz,
                            label: 'Dipinjam',
                            value: _stats['dipinjam']!,
                            color: Colors.orange,
                          ),
                          _buildStatCard(
                            icon: Icons.report_problem_outlined,
                            label: 'Rusak',
                            value: _stats['rusak']!,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      tablet: Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.check_circle_outline,
                            label: 'Alat tersedia',
                            value: _stats['tersedia']!,
                            color: Colors.green,
                          ),
                          _buildStatCard(
                            icon: Icons.swap_horiz,
                            label: 'Sedang dipinjam',
                            value: _stats['dipinjam']!,
                            color: Colors.orange,
                          ),
                          _buildStatCard(
                            icon: Icons.report_problem_outlined,
                            label: 'Alat rusak',
                            value: _stats['rusak']!,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      desktop: Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.check_circle_outline,
                            label: 'Alat tersedia',
                            value: _stats['tersedia']!,
                            color: Colors.green,
                          ),
                          _buildStatCard(
                            icon: Icons.swap_horiz,
                            label: 'Sedang dipinjam',
                            value: _stats['dipinjam']!,
                            color: Colors.orange,
                          ),
                          _buildStatCard(
                            icon: Icons.report_problem_outlined,
                            label: 'Alat rusak',
                            value: _stats['rusak']!,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Permintaan Peminjaman',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_pendingRequests.isEmpty)
                      const Text('Tidak ada permintaan pending')
                    else
                      ..._pendingRequests
                          .map((req) => _buildRequestCard(req, dateFormat)),

                    const SizedBox(height: 32),

                    // Form Ajukan Peminjaman
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Ajukan Peminjaman Baru',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _namaSiswaController,
                                  decoration: _inputDeco('Nama Siswa'),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _namaAlatController,
                                  decoration: _inputDeco('Nama Alat'),
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedKelas,
                                  decoration: _inputDeco('Kelas'),
                                  items: const [
                                    DropdownMenuItem(
                                        value: '10', child: Text('10')),
                                    DropdownMenuItem(
                                        value: '11', child: Text('11')),
                                    DropdownMenuItem(
                                        value: '12', child: Text('12')),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _selectedKelas = v),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: _timeField('Jam', true)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: _timeField('Selesai', false)),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => _resetForm(),
                                      child: const Text('Batal',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Pengajuan berhasil dikirim')),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFF9800),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      child: const Text('Simpan'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _buildHeaderMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.build, color: Color(0xFFFF9800), size: 28),
            ),
            const SizedBox(width: 12),
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
            DropdownButton<String>(
              value: _selectedRole,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              items: ['Admin', 'Petugas'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => _selectedRole = newValue);
                }
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
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
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
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 20),
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.build, color: Color(0xFFFF9800), size: 40),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SISTEM PEMINJAMAN ALAT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Teknik Pembangkit - Dashboard Petugas',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
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
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.waving_hand,
                          color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Selamat datang, $_selectedRole',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedRole,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: const SizedBox(),
                  items: ['Admin', 'Petugas'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _selectedRole = newValue);
                    }
                  },
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            width: double.infinity,
            color: const Color(0xFFFF9800),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.build, color: Color(0xFFFF9800), size: 40),
                ),
                SizedBox(height: 15),
                Text(
                  "PEMINJAMAN ALAT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Petugas Dashboard",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Data Peminjaman'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.peminjamanListPetugas);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_return),
            title: const Text('Pengembalian'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.peminjamanListPetugas);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_turned_in),
            title: const Text('Persetujuan Peminjaman'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.persetujuanPeminjaman);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Log Aktivitas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Scaffold(
                        body: SafeArea(child: LogAktivitasScreen()))),
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Keluar', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              AppRoutes.navigateToLogin(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Widgets & Helpers ────────────────────────────────

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color.withOpacity(0.9), fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(PeminjamanModel req, DateFormat dateFormat) {
    final status = req.status;
    Color cardColor = Colors.orange.shade50;
    Color accentColor = Colors.orange;
    String statusLabel = req.statusLabel;

    if (status == 'disetujui') {
      cardColor = Colors.green.shade50;
      accentColor = Colors.green;
    } else if (status == 'ditolak') {
      cardColor = Colors.red.shade50;
      accentColor = Colors.red;
    }

    final inisial = req.user?.nama.isNotEmpty == true
        ? req.user!.nama[0].toUpperCase()
        : '?';

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          color: cardColor,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: accentColor.withOpacity(0.2),
                      child: Text(
                        inisial,
                        style: TextStyle(
                            color: accentColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req.user?.nama ?? 'User',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Peminjam • ${dateFormat.format(req.tanggalPinjam)}',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          req.details?.map((d) => d.alat?.nama).join(', ') ??
                              'No Alat',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: accentColor),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (status == 'menunggu')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Tolak'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Setuju'),
                      ),
                    ],
                  )
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeField(String label, bool isStart) {
    return GestureDetector(
      onTap: () => _pickTime(isStart),
      child: InputDecorator(
        decoration: _inputDeco(label),
        child: Text(
          isStart
              ? (_jamMulai?.format(context) ?? 'Pilih')
              : (_jamSelesai?.format(context) ?? 'Pilih'),
          style: TextStyle(
            color: (isStart ? _jamMulai : _jamSelesai) != null
                ? Colors.black87
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _resetForm() {
    _namaSiswaController.clear();
    _namaAlatController.clear();
    setState(() {
      _selectedKelas = null;
      _jamMulai = null;
      _jamSelesai = null;
    });
  }

  @override
  void dispose() {
    _namaSiswaController.dispose();
    _namaAlatController.dispose();
    super.dispose();
  }
}
