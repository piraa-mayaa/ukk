import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/peminjaman_model.dart';
import '../../../services/service_peminjaman.dart';

class PersetujuanPeminjaman extends StatefulWidget {
  const PersetujuanPeminjaman({super.key});

  @override
  State<PersetujuanPeminjaman> createState() => _PersetujuanPeminjamanState();
}

class _PersetujuanPeminjamanState extends State<PersetujuanPeminjaman> {
  final ServicePeminjaman _service = ServicePeminjaman();
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

  Future<List<PeminjamanModel>> _loadPengajuan() async {
    // Load peminjaman with status 'menunggu'
    return await _service.getPeminjamanByStatus('menunggu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Persetujuan Peminjaman'),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<PeminjamanModel>>(
        future: _loadPengajuan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final pengajuanList = snapshot.data ?? [];

          if (pengajuanList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada pengajuan menunggu persetujuan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pengajuanList.length,
              itemBuilder: (context, index) {
                final peminjaman = pengajuanList[index];
                return _buildPeminjamanCard(peminjaman);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeminjamanCard(PeminjamanModel peminjaman) {
    final jumlahAlat = peminjaman.details?.length ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        peminjaman.namaPeminjam ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID Peminjaman: #${peminjaman.id}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.pending, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        'Menunggu',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Detail Tanggal
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.event,
                    label: 'Tgl Pinjam',
                    value: _dateFormat.format(peminjaman.tanggalPinjam),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.event_available,
                    label: 'Tgl Kembali',
                    value: _dateFormat.format(peminjaman.tanggalKembali),
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Alat List
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.devices, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Alat yang Dipinjam ($jumlahAlat item)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...?peminjaman.details?.map((detail) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF9800),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                detail.namaAlat ?? 'Unknown',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Text(
                              detail.kodeAlat ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRejectDialog(peminjaman),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Tolak'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showApproveDialog(peminjaman),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Setujui'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showApproveDialog(PeminjamanModel peminjaman) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setujui Peminjaman?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Peminjam: ${peminjaman.namaPeminjam}'),
            const SizedBox(height: 8),
            Text('Jumlah alat: ${peminjaman.details?.length ?? 0} item'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Status alat akan berubah menjadi "Dipinjam"',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _approvePeminjaman(peminjaman.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Setujui'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(PeminjamanModel peminjaman) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Peminjaman?'),
        content: Text(
          'Apakah Anda yakin ingin menolak pengajuan dari ${peminjaman.namaPeminjam}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _rejectPeminjaman(peminjaman.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Tolak'),
          ),
        ],
      ),
    );
  }

  Future<void> _approvePeminjaman(int id) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await _service.approvePeminjaman(id);

    // Hide loading
    if (mounted) Navigator.pop(context);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? '✅ Peminjaman disetujui'
                : '❌ Gagal menyetujui peminjaman',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        // Refresh list
        setState(() {});
      }
    }
  }

  Future<void> _rejectPeminjaman(int id) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await _service.rejectPeminjaman(id);

    // Hide loading
    if (mounted) Navigator.pop(context);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? '✅ Peminjaman ditolak' : '❌ Gagal menolak peminjaman',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        // Refresh list
        setState(() {});
      }
    }
  }
}
