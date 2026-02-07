import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/peminjaman_model.dart';
import '../../../services/service_pengembalian.dart';

class PengembalianForm extends StatefulWidget {
  final PeminjamanModel peminjaman;

  const PengembalianForm({super.key, required this.peminjaman});

  @override
  State<PengembalianForm> createState() => _PengembalianFormState();
}

class _PengembalianFormState extends State<PengembalianForm> {
  final ServicePengembalian _service = ServicePengembalian();
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

  DateTime _tanggalKembali = DateTime.now();
  String _kondisi = 'baik';
  double _denda = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _calculateDenda();
  }

  Future<void> _calculateDenda() async {
    final denda = await _service.calculateDenda(
      widget.peminjaman.id,
      _tanggalKembali,
    );
    setState(() => _denda = denda);
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final success = await _service.processKembalian(
      idPeminjaman: widget.peminjaman.id,
      tanggalDikembalikan: _tanggalKembali,
      kondisiKembali: _kondisi,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Pengembalian berhasil diproses')),
        );
        Navigator.pop(context, true); // Return true to refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Gagal memproses pengembalian')),
        );
      }
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalKembali,
      firstDate: widget.peminjaman.tanggalPinjam,
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _tanggalKembali = picked);
      _calculateDenda();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proses Pengembalian'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Peminjaman
            _buildInfoCard(),
            const SizedBox(height: 24),

            const Text('Form Pengembalian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Tanggal Kembali
            ListTile(
              title: const Text('Tanggal Dikembalikan'),
              subtitle: Text(_dateFormat.format(_tanggalKembali)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 16),

            // Kondisi
            DropdownButtonFormField<String>(
              value: _kondisi,
              decoration: InputDecoration(
                labelText: 'Kondisi Alat',
                filled: true,
                fillColor: Colors.grey[100],
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'baik', child: Text('Baik')),
                DropdownMenuItem(value: 'rusak', child: Text('Rusak')),
                DropdownMenuItem(value: 'hilang', child: Text('Hilang')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _kondisi = val);
              },
            ),
            const SizedBox(height: 24),

            // Denda Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _denda > 0 ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _denda > 0 ? Colors.red : Colors.green,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Denda:', style: TextStyle(fontSize: 16)),
                  Text(
                    'Rp ${_denda.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _denda > 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Pengembalian',
                        style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Peminjam: ${widget.peminjaman.user?.nama ?? '-'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Text(
                'Tenggat Kembali: ${_dateFormat.format(widget.peminjaman.tanggalKembali)}'),
            const SizedBox(height: 8),
            const Text('Alat:', style: TextStyle(fontWeight: FontWeight.w500)),
            ...?widget.peminjaman.details?.map((d) => Text('• ${d.namaAlat}')),
          ],
        ),
      ),
    );
  }
}
