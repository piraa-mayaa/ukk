import 'package:flutter/material.dart';

class EditKategoriPage extends StatelessWidget {
  final String nama;
  final String keterangan;

  const EditKategoriPage({
    super.key,
    required this.nama,
    required this.keterangan,
  });

  @override
  Widget build(BuildContext context) {
    return _FormKategori(
      title: 'Edit Kategori',
      namaAwal: nama,
      keteranganAwal: keterangan,
    );
  }
}

class _FormKategori extends StatelessWidget {
  final String title;
  final String? namaAwal;
  final String? keteranganAwal;

  const _FormKategori({
    required this.title,
    this.namaAwal,
    this.keteranganAwal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC97C),
        elevation: 0,
        title: Text(title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBCB),
                  borderRadius: BorderRadius.circular(18),
                ),
                child:
                    const Icon(Icons.image, size: 40, color: Colors.orange),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: namaAwal),
                decoration: _inputDecoration('Nama kategori'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: keteranganAwal),
                decoration: _inputDecoration('Keterangan'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFFFF3D9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
