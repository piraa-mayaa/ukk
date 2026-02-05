import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class KategoriListPage extends StatelessWidget {
  const KategoriListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC97C),
        elevation: 0,
        title: const Text(
          'Kategori',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFFFF1D6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/kategori/tambah');
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                KategoriCard(
                  nama: 'Oscilloscope',
                  keterangan: 'Alat ukur',
                  onEdit: () {
                    Navigator.pushNamed(context, '/kategori/edit');
                  },
                ),
                KategoriCard(
                  nama: 'Multimeter',
                  keterangan: 'Alat ukur listrik',
                  onEdit: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
