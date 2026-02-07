import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/service_peminjaman.dart';
import '../../models/peminjaman_model.dart';

class PersetujuanScreen extends StatefulWidget {
  const PersetujuanScreen({super.key});

  @override
  State<PersetujuanScreen> createState() => _PersetujuanScreenState();
}

class _PersetujuanScreenState extends State<PersetujuanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ServicePeminjaman _servicePeminjaman = ServicePeminjaman();
  List<PeminjamanModel> _allRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() => _isLoading = true);
    final requests = await _servicePeminjaman.getAllPeminjaman();
    setState(() {
      _allRequests = requests;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleApprove(int id) async {
    final success = await _servicePeminjaman.approvePeminjaman(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peminjaman disetujui')),
      );
      _fetchRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyetujui peminjaman')),
      );
    }
  }

  Future<void> _handleReject(int id) async {
    final success = await _servicePeminjaman.rejectPeminjaman(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peminjaman ditolak')),
      );
      _fetchRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menolak peminjaman')),
      );
    }
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

    final filtered =
        _allRequests.where((r) => r.status == currentStatus).toList();

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
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.build_circle,
                          color: Color(0xFFFF9800), size: 32),
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
                            'Persetujuan Peminjaman',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Judul halaman
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Persetujuan',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _fetchRequests,
                  icon: const Icon(Icons.refresh),
                ),
              ],
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
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

  Widget _buildList(List<PeminjamanModel> requests, DateFormat dateFormat) {
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
        final status = req.status;

        Color cardBg = Colors.orange.shade50;
        Color accent = Colors.orange;
        String actionText = req.statusLabel;

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

        final inisial = req.namaPeminjam?.substring(0, 1).toUpperCase() ?? '?';

        return Card(
          color: cardBg,
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        inisial,
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
                            req.namaPeminjam ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'ID Peminjaman: ${req.id} • ${dateFormat.format(req.tanggalPinjam)}',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Daftar alat
                const Text(
                  'Alat yang dipinjam:',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
                const SizedBox(height: 8),
                ...?req.details?.map((detail) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.devices,
                                size: 16, color: Colors.blueGrey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                detail.namaAlat ?? 'Alat tidak dikenal',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 20),

                // Tombol aksi
                if (status == 'menunggu')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => _handleReject(req.id),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Tolak'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => _handleApprove(req.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
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
                          horizontal: 20, vertical: 10),
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
