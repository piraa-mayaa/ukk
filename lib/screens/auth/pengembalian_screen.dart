import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PengembalianScreen extends StatefulWidget {
  const PengembalianScreen({super.key});

  @override
  State<PengembalianScreen> createState() => _PengembalianScreenState();
}

class _PengembalianScreenState extends State<PengembalianScreen> {
  final _formKey = GlobalKey<FormState>();

  final _kategoriController = TextEditingController();
  final _unitController = TextEditingController();
  DateTime? _tglKembali;
  String _kondisi = 'Baik';

  String _searchQuery = '';

  // Dummy data pengembalian
  final List<Map<String, dynamic>> _pengembalianList = [
    {
      'kategori': 'Tang Amper',
      'unit': '1',
      'tglKembali': DateTime(2026, 1, 14),
      'kondisi': 'Baik',
    },
    {
      'kategori': 'Multimeter',
      'unit': '1',
      'tglKembali': DateTime(2026, 1, 13),
      'kondisi': 'Baik',
    },
    {
      'kategori': 'Frequency Meter',
      'unit': '1',
      'tglKembali': DateTime(2026, 1, 13),
      'kondisi': 'Rusak',
    },
    {
      'kategori': 'Thermometer Digital',
      'unit': '1',
      'tglKembali': DateTime(2026, 1, 12),
      'kondisi': 'Rusak',
    },
  ];

  Future<void> _pickDate() async {
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
      setState(() => _tglKembali = picked);
    }
  }

  void _showDeleteDialog(String kategori) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapusnya?\n\n$kategori'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _pengembalianList.removeWhere((e) => e['kategori'] == kategori);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$kategori dihapus')),
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
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  Color _getKondisiColor(String kondisi) {
    return kondisi == 'Baik' ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 960;

    final filteredList = _pengembalianList.where((item) {
      final kat = item['kategori'].toString().toLowerCase();
      return kat.contains(_searchQuery.toLowerCase());
    }).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Form (kiri)
        Expanded(
          flex: isWide ? 4 : 1,
          child: _buildForm(),
        ),

        // List (kanan / bawah di mobile)
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
              'Pengembalian',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _kategoriController,
              decoration: _inputDecoration('Nama Kategori'),
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _unitController,
              decoration: _inputDecoration('Unit'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: _inputDecoration('Tgl Kembali'),
                child: Text(
                  _tglKembali != null ? dateFormat.format(_tglKembali!) : 'Pilih tanggal',
                  style: TextStyle(color: _tglKembali != null ? Colors.black : Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _kondisi,
              decoration: _inputDecoration('Kondisi'),
              items: const [
                DropdownMenuItem(value: 'Baik', child: Text('Baik')),
                DropdownMenuItem(value: 'Rusak', child: Text('Rusak')),
              ],
              onChanged: (v) => setState(() => _kondisi = v!),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _kategoriController.clear();
                    _unitController.clear();
                    setState(() {
                      _tglKembali = null;
                      _kondisi = 'Baik';
                    });
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[800]),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: simpan ke list / backend
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengembalian disimpan')),
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
            const SizedBox(height: 40),
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
                    // reset form jika diperlukan
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
                final kondisiColor = _getKondisiColor(item['kondisi']);

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
                                color: kondisiColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['kondisi'],
                                style: TextStyle(
                                  color: kondisiColor,
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
                                    // TODO: load data ke form untuk edit
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                  onPressed: () => _showDeleteDialog(item['kategori']),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['kategori'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Unit: ${item['unit']}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE0B2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'tgl kembali ${_formatDate(item['tglKembali'])}',
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
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
    _kategoriController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}