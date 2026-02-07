import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/alat_model_api.dart';
import '../../services/service_alat.dart';
import '../../services/service_peminjaman.dart';

class KeranjangPeminjaman extends StatefulWidget {
  final List<int>? selectedAlatIds;

  const KeranjangPeminjaman({super.key, this.selectedAlatIds});

  @override
  State<KeranjangPeminjaman> createState() => _KeranjangPeminjamanState();
}

class _KeranjangPeminjamanState extends State<KeranjangPeminjaman> {
  final ServiceAlat _serviceAlat = ServiceAlat();
  final ServicePeminjaman _servicePeminjaman = ServicePeminjaman();
  final _formKey = GlobalKey<FormState>();

  DateTime? _tanggalPinjam;
  DateTime? _tanggalKembali;
  bool _isLoading = false;
  List<AlatModel> _alats = [];

  @override
  void initState() {
    super.initState();
    _loadAlats();
  }

  Future<void> _loadAlats() async {
    if (widget.selectedAlatIds == null || widget.selectedAlatIds!.isEmpty) {
      return;
    }

    final allAlats = await _serviceAlat.getAlats();
    final selectedAlats = allAlats
        .where((alat) => widget.selectedAlatIds!.contains(alat.id))
        .toList();

    setState(() => _alats = selectedAlats);
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = _alats.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Keranjang Peminjaman'),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
      ),
      body: hasItems ? _buildKeranjangContent() : _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 100,
            color: Colors.orange.shade300,
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada alat yang dipilih',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Pilih Alat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeranjangContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'Alat yang Dipinjam',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Alat List
            ..._alats.map((alat) => _buildAlatItem(alat)),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Form Section
            const Text(
              'Detail Peminjaman',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Tanggal Pinjam
            _buildDateField(
              label: 'Tanggal Pinjam',
              value: _tanggalPinjam,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  setState(() => _tanggalPinjam = date);
                }
              },
            ),
            const SizedBox(height: 16),

            // Tanggal Kembali
            _buildDateField(
              label: 'Tanggal Kembali',
              value: _tanggalKembali,
              onTap: () async {
                final firstDate = _tanggalPinjam ?? DateTime.now();
                final date = await showDatePicker(
                  context: context,
                  initialDate: firstDate.add(const Duration(days: 1)),
                  firstDate: firstDate.add(const Duration(days: 1)),
                  lastDate: firstDate.add(const Duration(days: 90)),
                );
                if (date != null) {
                  setState(() => _tanggalKembali = date);
                }
              },
              validator: (value) {
                if (_tanggalKembali == null) {
                  return 'Pilih tanggal kembali';
                }
                if (_tanggalPinjam != null &&
                    _tanggalKembali!.isBefore(_tanggalPinjam!)) {
                  return 'Tanggal kembali harus setelah tanggal pinjam';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Keterlambatan pengembalian',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Denda Rp 5.000/hari jika terlambat',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitPeminjaman,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Ajukan Peminjaman',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlatItem(AlatModel alat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: alat.foto != null && alat.foto!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: alat.foto!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.devices, size: 30),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.devices, size: 30),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.devices, size: 30),
                ),
        ),
        title: Text(
          alat.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(alat.kode),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            alat.kondisi ?? 'Baik',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.calendar_today),
          errorText: validator != null ? validator(value?.toString()) : null,
        ),
        child: Text(
          value != null ? dateFormat.format(value) : 'Pilih tanggal',
          style: TextStyle(
            color: value != null ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPeminjaman() async {
    // Validate
    if (_tanggalPinjam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal pinjam')),
      );
      return;
    }

    if (_tanggalKembali == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal kembali')),
      );
      return;
    }

    if (_tanggalKembali!.isBefore(_tanggalPinjam!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal kembali harus setelah tanggal pinjam'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Get current user ID from session/auth
      // For now using hardcoded idUser = 1 (change this!)
      final idUser = 1; // Replace with actual user ID from auth/session

      final idPeminjaman = await _servicePeminjaman.createPeminjaman(
        idUser: idUser,
        tanggalPinjam: _tanggalPinjam!,
        tanggalKembali: _tanggalKembali!,
        idAlatList: widget.selectedAlatIds!,
      );

      setState(() => _isLoading = false);

      if (idPeminjaman != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Pengajuan peminjaman berhasil!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back or to riwayat
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Gagal mengajukan peminjaman'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
