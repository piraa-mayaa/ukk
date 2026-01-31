import 'package:flutter/material.dart';

class TambahKategoriPage extends StatelessWidget {
  const TambahKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FormKategori(title: 'Tambah Kategori');
  }
}

// ================= FORM KATEGORI =================
class _FormKategori extends StatelessWidget {
  final String title;

  const _FormKategori({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC97C),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              // IMAGE
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBCB),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 16),

              // NAMA KATEGORI
              TextField(
                decoration: _inputDecoration('Nama kategori'),
              ),

              const SizedBox(height: 12),

              // KETERANGAN
              TextField(
                decoration: _inputDecoration('Keterangan'),
              ),

              const SizedBox(height: 20),

              // BUTTON
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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

  static InputDecoration _inputDecoration(String hint) {
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
