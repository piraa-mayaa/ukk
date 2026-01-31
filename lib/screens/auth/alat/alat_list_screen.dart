import 'package:flutter/material.dart';
import 'package:ukk/widgets/alat_card.dart';

class AlatList extends StatelessWidget {
  const AlatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC97C),
        elevation: 0,
        title: const Text(
          'Data Alat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Text('Admin'),
                SizedBox(width: 6),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, size: 14, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // ================= SEARCH =================
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
                      fillColor: const Color(0xFFFFEBCB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),

          // ================= LIST =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                AlatCard(
                  nama: 'Oscilloscope',
                  kondisi: 'Baik',
                  stok: 2,
                  image: 'assets/alat/oscilloscope.png',
                ),
                AlatCard(
                  nama: 'Tang Amper',
                  kondisi: 'Baik',
                  stok: 4,
                  image: 'assets/alat/tang_amper.png',
                ),
                AlatCard(
                  nama: 'Multimeter',
                  kondisi: 'Baik',
                  stok: 6,
                  image: 'assets/alat/multimeter.png',
                ),
                AlatCard(
                  nama: 'Power Supply',
                  kondisi: 'Baik',
                  stok: 3,
                  image: 'assets/alat/power_supply.png',
                ),
                AlatCard(
                  nama: 'Compressor Mini',
                  kondisi: 'Baik',
                  stok: 1,
                  image: 'assets/alat/compressor.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
