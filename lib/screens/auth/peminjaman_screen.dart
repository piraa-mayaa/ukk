// lib/screens/peminjaman_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // tambahkan dependency: intl di pubspec.yaml

class PeminjamanScreen extends StatefulWidget {
  const PeminjamanScreen({super.key});

  @override
  State<PeminjamanScreen> createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  DateTime? _tglPinjam;
  DateTime? _tglKembali;
  String _status = 'Dipinjam';

  // Dummy data (sesuaikan dengan API nanti)
  final List<Map<String, dynamic>> _peminjamanList = [
    {
      'nama': 'Fairuz Fadillah',
      'kelas': '12',
      'tglPinjam': DateTime(2026, 1, 12),
      'tglKembali': DateTime(2026, 1, 14),
      'status': 'Dipinjam',
    },
    {
      'nama': 'Aprilila Soviana',
      'kelas': '12',
      'tglPinjam': DateTime(2026, 1, 12),
      'tglKembali': DateTime(2026, 1, 13),
      'status': 'Dipinjam',
    },
    {
      'nama': 'Nafil Irsyad',
      'kelas': '12',
      'tglPinjam': DateTime(2026, 1, 12),
      'tglKembali': DateTime(2026, 1, 13),
      'status': 'Terlambat',
    },
    {
      'nama': 'Novi Angel',
      'kelas': '12',
      'tglPinjam': DateTime(2026, 1, 13),
      'tglKembali': DateTime(2026, 1, 12),
      'status': 'Terlambat',
    },
  ];

  String _searchQuery = '';

  Future<void> _pickDate(bool isPinjam) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFFF9800),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isPinjam) _tglPinjam = picked;
        if (!isPinjam) _tglKembali = picked;
      });
    }
  }

  void _showDeleteDialog(String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapusnya?\n\n$nama'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _peminjamanList.removeWhere((e) => e['nama'] == nama);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$nama dihapus')),
              );
            },
            child: const Text('Iya', style: TextStyle(color: Color(0xFFFF9800))),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy', 'id_ID').format(date).replaceAll('.', '');
  }

  Color _getStatusColor(String status) {
    return status == 'Dipinjam' ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 960;

    final filteredList = _peminjamanList.where((item) {
      final nama = item['nama'].toString().toLowerCase();
      return nama.contains(_searchQuery.toLowerCase());
    }).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Form Section (kiri)
        Expanded(
          flex: isWide ? 4 : 1,
          child: _buildForm(),
        ),

        // List Section (kanan) - full width di mobile
        if (isWide || !isWide)
          Expanded(
            flex: isWide ? 6 : 1,
            child: _buildList(filteredList),
          ),
      ],
    );
  }

  Widget _buildForm() {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    return Container(
      color: const Color(0xFFFFF8E1),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Peminjaman',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _namaController,
              decoration: _inputDecoration('Nama Peminjam'),
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _kelasController,
              decoration: _inputDecoration('Kelas'),
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(true),
                    child: InputDecorator(
                      decoration: _inputDecoration('Tgl Pinjam'),
                      child: Text(
                        _tglPinjam != null ? dateFormat.format(_tglPinjam!) : 'Pilih tanggal',
                        style: TextStyle(color: _tglPinjam != null ? Colors.black : Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(false),
                    child: InputDecorator(
                      decoration: _inputDecoration('Tgl Kembali'),
                      child: Text(
                        _tglKembali != null ? dateFormat.format(_tglKembali!) : 'Pilih tanggal',
                        style: TextStyle(color: _tglKembali != null ? Colors.black : Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _status,
              decoration: _inputDecoration('Status Peminjaman'),
              items: const [
                DropdownMenuItem(value: 'Dipinjam', child: Text('Dipinjam')),
                DropdownMenuItem(value: 'Terlambat', child: Text('Terlambat')),
                DropdownMenuItem(value: 'Dikembalikan', child: Text('Dikembalikan')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _namaController.clear();
                    _kelasController.clear();
                    setState(() {
                      _tglPinjam = null;
                      _tglKembali = null;
                      _status = 'Dipinjam';
                    });
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[800]),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: simpan ke list / API
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Peminjaman disimpan')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list) {
    return Container(
      color: const Color(0xFFFFF8E1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Cari',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton.small(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    // reset form jika perlu
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                final isTerlambat = item['status'] == 'Terlambat';
                final statusColor = _getStatusColor(item['status']);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['status'],
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20, color: Color(0xFFFF9800)),
                                  onPressed: () {
                                    // TODO: isi form dengan data item untuk edit
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                  onPressed: () => _showDeleteDialog(item['nama']),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['nama'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kelas ${item['kelas']}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildDateTag('tgl pinjam', _formatDate(item['tglPinjam'])),
                            const SizedBox(width: 12),
                            _buildDateTag('tgl kembali', _formatDate(item['tglKembali'])),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTag(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label $value',
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kelasController.dispose();
    super.dispose();
  }
}