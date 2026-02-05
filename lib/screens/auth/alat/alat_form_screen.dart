import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ukk/models/alat_model_api.dart';
import 'package:ukk/models/kategori_model.dart';
import 'package:ukk/services/supabase_service.dart';

class AlatFormScreen extends StatefulWidget {
  final AlatModel? alat;
  const AlatFormScreen({super.key, this.alat});

  @override
  State<AlatFormScreen> createState() => _AlatFormScreenState();
}

class _AlatFormScreenState extends State<AlatFormScreen> {
  final _kodeCtl = TextEditingController();
  final _namaCtl = TextEditingController();
  final _kondisiCtl = TextEditingController();
  final _statusCtl = TextEditingController();
  int? _kategoriId;
  String? _pickedPath;
  Uint8List? _pickedBytes;

  final _s = SupabaseService();
  List<KategoriModel> _kategoris = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.alat != null) {
      _kodeCtl.text = widget.alat!.kode;
      _namaCtl.text = widget.alat!.nama;
      _kondisiCtl.text = widget.alat!.kondisi ?? '';
      _statusCtl.text = widget.alat!.status ?? '';
      _kategoriId = widget.alat!.idKategori;
    }
    _loadKategoris();
  }

  Future<void> _loadKategoris() async {
    final list = await _s.getKategoris();
    setState(() => _kategoris = list);
  }

  Future<void> _pickFile() async {
    final res = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (res != null && res.files.isNotEmpty) {
      setState(() {
        _pickedBytes = res.files.first.bytes;
        _pickedPath = res.files.first.name;
      });
    }
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    String? url = widget.alat?.fotoUrl;
    if (_pickedBytes != null && _pickedPath != null) {
      final filename =
          'alat_${DateTime.now().millisecondsSinceEpoch}_$_pickedPath';
      url = await _s.uploadFileToBucket('alat', _pickedBytes!, filename,
          contentType: 'image/jpeg');
    }

    bool ok = false;
    if (widget.alat == null) {
      final created = await _s.createAlat(
        kodeAlat: _kodeCtl.text,
        namaAlat: _namaCtl.text,
        kondisi: _kondisiCtl.text.isEmpty ? null : _kondisiCtl.text,
        status: _statusCtl.text.isEmpty ? null : _statusCtl.text,
        idKategori: _kategoriId,
        fotoPath: url,
      );
      ok = created != null;
    } else {
      ok = await _s.updateAlat(widget.alat!.id,
          namaAlat: _namaCtl.text,
          kodeAlat: _kodeCtl.text,
          kondisi: _kondisiCtl.text.isEmpty ? null : _kondisiCtl.text,
          status: _statusCtl.text.isEmpty ? null : _statusCtl.text,
          idKategori: _kategoriId,
          fotoPath: url);
    }

    setState(() => _loading = false);
    if (ok) Navigator.pop(context, true);
    if (!ok)
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Gagal menyimpan')));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.alat != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Alat' : 'Tambah Alat')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                  controller: _kodeCtl,
                  decoration: const InputDecoration(labelText: 'Kode Alat')),
              const SizedBox(height: 8),
              TextField(
                  controller: _namaCtl,
                  decoration: const InputDecoration(labelText: 'Nama Alat')),
              const SizedBox(height: 8),
              TextField(
                  controller: _kondisiCtl,
                  decoration: const InputDecoration(labelText: 'Kondisi')),
              const SizedBox(height: 8),
              TextField(
                  controller: _statusCtl,
                  decoration: const InputDecoration(labelText: 'Status')),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                value: _kategoriId,
                items: _kategoris
                    .map((k) =>
                        DropdownMenuItem(value: k.id, child: Text(k.nama)))
                    .toList(),
                onChanged: (v) => setState(() => _kategoriId = v),
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.image),
                      label: const Text('Pilih Foto')),
                  const SizedBox(width: 12),
                  if (_pickedBytes != null)
                    const Text('File dipilih')
                  else if (widget.alat?.fotoUrl != null)
                    const Text('Menggunakan foto lama')
                  else
                    const Text('Belum ada foto'),
                ],
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Alat'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
