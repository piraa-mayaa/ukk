import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/peminjaman_model.dart';
import '../../../services/service_peminjaman.dart';

class RiwayatPeminjamanUser extends StatefulWidget {
  final int idUser; // Pass from navigation or get from auth

  const RiwayatPeminjamanUser({super.key, required this.idUser});

  @override
  State<RiwayatPeminjamanUser> createState() => _RiwayatPeminjamanUserState();
}

class _RiwayatPeminjamanUserState extends State<RiwayatPeminjamanUser> {
  final ServicePeminjaman _service = ServicePeminjaman();
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
  String? _filterStatus;

  Future<List<PeminjamanModel>> _loadRiwayat() async {
    final allPeminjaman = await _service.getPeminjamanByUser(widget.idUser);

    if (_filterStatus == null) {
      return allPeminjaman;
    }

    return allPeminjaman.where((p) => p.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterStatus = value == 'all' ? null : value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Semua Status')),
              const PopupMenuItem(value: 'menunggu', child: Text('Menunggu')),
              const PopupMenuItem(value: 'disetujui', child: Text('Disetujui')),
              const PopupMenuItem(value: 'ditolak', child: Text('Ditolak')),
              const PopupMenuItem(value: 'selesai', child: Text('Selesai')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to daftar alat
          Navigator.pushNamed(context, '/daftar-alat');
        },
        backgroundColor: const Color(0xFFFF9800),
        icon: const Icon(Icons.add),
        label: const Text('Pinjam Alat'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<PeminjamanModel>>(
          future: _loadRiwayat(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final riwayatList = snapshot.data ?? [];

            if (riwayatList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      _filterStatus == null
                          ? 'Belum ada riwayat peminjaman'
                          : 'Tidak ada peminjaman dengan status ini',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riwayatList.length,
              itemBuilder: (context, index) {
                final peminjaman = riwayatList[index];
                return _buildPeminjamanCard(peminjaman);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeminjamanCard(PeminjamanModel peminjaman) {
    final statusColor = _getStatusColor(peminjaman.status);
    final jumlahAlat = peminjaman.details?.length ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () => _showDetailDialog(peminjaman),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID #${peminjaman.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      peminjaman.statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Info
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.devices,
                      label: 'Jumlah Alat',
                      value: '$jumlahAlat item',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.calendar_today,
                      label: 'Tgl Pinjam',
                      value: _dateFormat.format(peminjaman.tanggalPinjam),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _buildInfoItem(
                icon: Icons.event_available,
                label: 'Tgl Kembali',
                value: _dateFormat.format(peminjaman.tanggalKembali),
              ),

              // Action button for approved peminjaman
              if (peminjaman.isDisetujui) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to pengembalian form
                      Navigator.pushNamed(
                        context,
                        '/pengembalian',
                        arguments: peminjaman.id,
                      );
                    },
                    icon: const Icon(Icons.assignment_return),
                    label: const Text('Kembalikan Alat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'menunggu':
        return Colors.orange;
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'selesai':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showDetailDialog(PeminjamanModel peminjaman) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Peminjaman #${peminjaman.id}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(peminjaman.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(peminjaman.status),
                      color: _getStatusColor(peminjaman.status),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            peminjaman.statusLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(peminjaman.status),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tanggal
              Text(
                'Periode Peminjaman',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text('Pinjam: ${_dateFormat.format(peminjaman.tanggalPinjam)}'),
              Text('Kembali: ${_dateFormat.format(peminjaman.tanggalKembali)}'),

              const SizedBox(height: 16),

              // Alat List
              Text(
                'Daftar Alat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              ...?peminjaman.details?.map((detail) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 16, color: Color(0xFFFF9800)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(detail.namaAlat ?? 'Unknown')),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'menunggu':
        return Icons.pending;
      case 'disetujui':
        return Icons.check_circle;
      case 'ditolak':
        return Icons.cancel;
      case 'selesai':
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }
}
