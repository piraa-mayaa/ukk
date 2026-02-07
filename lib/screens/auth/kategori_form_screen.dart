// lib/screens/auth/kategori/kategori_form_screen.dart
import 'package:flutter/material.dart';
import '../../../models/kategori_model.dart';
import '../../../services/service_kategori.dart';

class KategoriFormScreen extends StatefulWidget {
  final KategoriModel? kategori;

  const KategoriFormScreen({super.key, this.kategori});

  @override
  State<KategoriFormScreen> createState() => _KategoriFormScreenState();
}

class _KategoriFormScreenState extends State<KategoriFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ServiceKategori();

  late TextEditingController _namaController;
  late TextEditingController _keteranganController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.kategori?.nama ?? '');
    _keteranganController =
        TextEditingController(text: widget.kategori?.keterangan ?? '');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final nama = _namaController.text.trim();
    final keterangan = _keteranganController.text.trim().isEmpty
        ? null
        : _keteranganController.text.trim();

    // Cek duplikasi nama
    final isDuplicate = await _service.isNamaKategoriExists(
      nama,
      excludeId: widget.kategori?.id,
    );

    if (isDuplicate) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama kategori sudah digunakan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool success = false;

    if (widget.kategori == null) {
      // Create new
      final created = await _service.createKategori(
        nama: nama,
        keterangan: keterangan,
      );
      success = created != null;
    } else {
      // Update existing
      success = await _service.updateKategori(
        id: widget.kategori!.id,
        nama: nama,
        keterangan: keterangan,
      );
    }

    setState(() => _loading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.kategori == null
                ? 'Kategori berhasil ditambahkan'
                : 'Kategori berhasil diperbarui',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan kategori'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.kategori != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kategori' : 'Tambah Kategori'),
        backgroundColor: const Color(0xFFF9D59B),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nama Kategori
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Kategori *',
                hintText: 'Contoh: Oscilloscope',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFF9D59B),
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama kategori harus diisi';
                }
                if (value.trim().length < 3) {
                  return 'Nama kategori minimal 3 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Keterangan
            TextFormField(
              controller: _keteranganController,
              decoration: InputDecoration(
                labelText: 'Keterangan (opsional)',
                hintText: 'Contoh: Alat ukur gelombang',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFF9D59B),
                    width: 2,
                  ),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 24),

            // Info ID (hanya saat edit)
            if (isEdit && widget.kategori != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID Kategori: ${widget.kategori!.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kategori akan digunakan untuk mengelompokkan alat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Button Simpan
            ElevatedButton(
              onPressed: _loading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9D59B),
                foregroundColor: Colors.black87,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save),
                        const SizedBox(width: 8),
                        Text(
                          isEdit ? 'Simpan Perubahan' : 'Tambah Kategori',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 12),

            // Button Batal
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }
}
