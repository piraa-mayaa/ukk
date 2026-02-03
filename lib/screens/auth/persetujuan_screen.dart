import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersetujuanScreen extends StatefulWidget {
  const PersetujuanScreen({super.key});

  @override
  State<PersetujuanScreen> createState() => _PersetujuanScreenState();
}

class _PersetujuanScreenState extends State<PersetujuanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRole = 'Petugas';

  // Dummy data semua permintaan (bisa diganti dengan API nanti)
  final List<Map<String, dynamic>> _allRequests = [
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'menunggu',
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'disetujui',
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'ditolak',
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'menunggu',
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'disetujui',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    // Filter data berdasarkan tab aktif
    final currentStatus = _tabController.index == 0
        ? 'menunggu'
        : _tabController.index == 1
            ? 'disetujui'
            : 'ditolak';

    final filtered = _allRequests.where((r) => r['status'] == currentStatus).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFFFF9800),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Logo
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.build_circle, color: Color(0xFFFF9800), size: 32),
                    ),
                    const SizedBox(width: 12),

                    // Judul aplikasi
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

                    // Notifikasi & Role
                    const Icon(Icons.notifications, color: Colors.white),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _selectedRole,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'Petugas', child: Text('Petugas')),
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

                // Greeting
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
          ),

          // Judul halaman
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: const Text(
              'Persetujuan',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFFF9800),
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: const Color(0xFFFF9800),
            indicatorWeight: 4,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Menunggu'),
              Tab(text: 'Disetujui'),
              Tab(text: 'Ditolak'),
            ],
          ),

          // Konten Tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(filtered, dateFormat),
                _buildList(filtered, dateFormat),
                _buildList(filtered, dateFormat),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> requests, DateFormat dateFormat) {
    if (requests.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada permintaan',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        final status = req['status'] as String;

        Color cardBg = Colors.orange.shade50;
        Color accent = Colors.orange;
        String actionText = 'Disetujui';

        if (status == 'menunggu') {
          cardBg = const Color(0xFFFFF3E0);
          accent = const Color(0xFFFF9800);
        } else if (status == 'disetujui') {
          cardBg = Colors.green.shade50;
          accent = Colors.green;
        } else if (status == 'ditolak') {
          cardBg = Colors.red.shade50;
          accent = Colors.red;
        }

        return Card(
          color: cardBg,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info user
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: accent.withOpacity(0.2),
                      child: Text(
                        req['inisial'],
                        style: TextStyle(
                          color: accent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req['nama'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${req['kelas']} • ${dateFormat.format(req['tanggal'])}',
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Nama alat
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          req['alat'],
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 16, color: accent),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol aksi
                if (status == 'menunggu')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // TODO: tolak permintaan
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Tolak'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: setujui permintaan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Setuju'),
                      ),
                    ],
                  )
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        actionText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}