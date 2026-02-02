import 'package:flutter/material.dart';
import 'tambah_user_page.dart';
import '../widgets/user_card.dart';

class DataUserPage extends StatelessWidget {
  const DataUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0A3),
      appBar: AppBar(
        title: const Text('Data User'),
        backgroundColor: const Color(0xFFFFD180),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari user',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TambahUserPage()),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                UserCard(nama: 'Admin Utama', role: 'Admin'),
                UserCard(nama: 'Petugas Lab', role: 'Petugas'),
                UserCard(nama: 'Siswa A', role: 'Peminjam'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
