import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ukk/models/alat_model_api.dart';
import 'package:ukk/models/kategori_model.dart';
import 'package:ukk/services/supabase_service.dart';
import 'package:ukk/services/service_alat.dart';
import 'package:ukk/services/service_kategori.dart';

class AlatFormScreen extends StatefulWidget {
  final AlatModel? alat;

  const AlatFormScreen({super.key, this.alat});

  @override
  State<AlatFormScreen> createState() => _AlatFormScreenState();
}

class _AlatFormScreenState extends State<AlatFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseService = SupabaseService();
  final _serviceAlat = ServiceAlat();
  final _serviceKategori = ServiceKategori();

  late TextEditingController _kodeController;
  late TextEditingController _namaController;

  String _kondisi = 'baik';
  String _status = 'tersedia';
  int? _selectedKategori;

  List<KategoriModel> _kategoriList = [];
  bool _loading = false;

  String? _pickedFileName;
  Uint8List? _pickedBytes;
  String? _existingPhotoUrl;

  @override
  void initState() {
    super.initState();

    _kodeController = TextEditingController(text: widget.alat?.kode ?? '');
    _namaController = TextEditingController(text: widget.alat?.nama ?? '');

    final alat = widget.alat;
    if (alat != null) {
      _kondisi = alat.kondisi ?? 'baik';
      _status = alat.status ?? 'tersedia';
      _selectedKategori = alat.idKategori;
      _existingPhotoUrl = alat.foto;
    }

    _loadKategori();
  }

  Future<void> _loadKategori() async {
    final data = await _serviceKategori.getAllKategori();
    setState(() => _kategoriList = data);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedBytes = result.files.first.bytes;
        _pickedFileName = result.files.first.name;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    String? photoUrl = _existingPhotoUrl;
    if (_pickedBytes != null && _pickedFileName != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'alat_${timestamp}_$_pickedFileName';

      photoUrl = await _supabaseService.uploadFileToBucket(
        'alat',
        _pickedBytes!,
        filename,
        contentType: 'image/jpeg',
      );

      if (photoUrl == null) {
        setState(() => _loading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengupload foto')),
        );
        return;
      }
    }

    bool success = false;
    if (widget.alat == null) {
      final created = await _serviceAlat.createAlat(
        kodeAlat: _kodeController.text.trim(),
        namaAlat: _namaController.text.trim(),
        kondisi: _kondisi,
        status: _status,
        idKategori: _selectedKategori,
        fotoPath: photoUrl,
      );
      success = created != null;
    } else {
      success = await _serviceAlat.updateAlat(
        widget.alat!.id,
        kodeAlat: _kodeController.text.trim(),
        namaAlat: _namaController.text.trim(),
        kondisi: _kondisi,
        status: _status,
        idKategori: _selectedKategori,
        fotoPath: photoUrl,
      );
    }

    setState(() => _loading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.alat == null
                ? 'Alat berhasil ditambahkan'
                : 'Alat berhasil diupdate',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.alat != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Alat' : 'Tambah Alat'),
        backgroundColor: const Color(0xFFFFC97C),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _kodeController,
              decoration: InputDecoration(
                labelText: 'Kode Alat *',
                hintText: 'Contoh: ALT001',
                prefixIcon: const Icon(Icons.qr_code),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) =>
                  v?.trim().isEmpty ?? true ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Alat *',
                hintText: 'Contoh: Mikroskop Digital',
                prefixIcon: const Icon(Icons.devices),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) =>
                  v?.trim().isEmpty ?? true ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedKategori,
              decoration: InputDecoration(
                labelText: 'Kategori',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _kategoriList
                  .map((k) => DropdownMenuItem<int>(
                        value: k.id,
                        child: Text(k.nama),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedKategori = v),
              hint: const Text('Pilih Kategori (opsional)'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kondisi,
              decoration: InputDecoration(
                labelText: 'Kondisi *',
                prefixIcon: const Icon(Icons.build),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem<String>(value: 'baik', child: Text('Baik')),
                DropdownMenuItem<String>(value: 'rusak', child: Text('Rusak')),
              ],
              onChanged: (v) => setState(() => _kondisi = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(
                labelText: 'Status *',
                prefixIcon: const Icon(Icons.info),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: 'tersedia',
                  child: Text('Tersedia'),
                ),
                DropdownMenuItem<String>(
                  value: 'dipinjam',
                  child: Text('Dipinjam'),
                ),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.image, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Foto Alat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _pickedBytes != null
                                ? Icons.check_circle
                                : (_existingPhotoUrl != null
                                    ? Icons.image
                                    : Icons.image_not_supported),
                            color: _pickedBytes != null
                                ? Colors.green
                                : (_existingPhotoUrl != null
                                    ? Colors.blue
                                    : Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _pickedBytes != null
                                  ? 'File baru dipilih: $_pickedFileName'
                                  : (_existingPhotoUrl != null
                                      ? 'Menggunakan foto yang ada'
                                      : 'Belum ada foto'),
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                            _pickedBytes != null ? 'Ganti Foto' : 'Pilih Foto'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC97C),
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
                          isEdit ? 'Simpan Perubahan' : 'Tambah Alat',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    super.dispose();
  }
}
