import 'package:flutter/material.dart';

/// ================= MODEL ALAT =================
/// (sementara di sini supaya tidak error import)
class Alat {
  String nama;
  String kategori;

  Alat({
    required this.nama,
    required this.kategori,
  });
}

class EditAlatPage extends StatefulWidget {
  final Alat alat;

  const EditAlatPage({super.key, required this.alat});

  @override
  State<EditAlatPage> createState() => _EditAlatPageState();
}

class _EditAlatPageState extends State<EditAlatPage> {
  late TextEditingController namaController;
  late String selectedKategori;

  final List<String> kategoriList = [
    'Alat Ukur',
    'Alat Listrik',
    'Alat Praktikum',
    'Alat Bengkel',
  ];

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.alat.nama);
    selectedKategori = widget.alat.kategori;
  }

  @override
  void dispose() {
    namaController.dispose(); // ✅ WAJIB supaya tidak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFC97C),
        title: const Text(
          'Edit Data Alat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
              // IMAGE PLACEHOLDER
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBCB),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.image, size: 40, color: Colors.orange),
              ),

              const SizedBox(height: 18),

              // NAMA ALAT
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  hintText: 'Nama alat',
                  filled: true,
                  fillColor: const Color(0xFFFFF3D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // KATEGORI
              DropdownButtonFormField<String>(
                value: selectedKategori,
                items: kategoriList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF3D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BUTTON
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        widget.alat.nama = namaController.text;
                        widget.alat.kategori = selectedKategori;

                        Navigator.pop(context, widget.alat);
                      },
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
