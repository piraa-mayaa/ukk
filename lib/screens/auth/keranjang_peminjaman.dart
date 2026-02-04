import 'package:flutter/material.dart';

class KeranjangPeminjaman extends StatelessWidget {
  const KeranjangPeminjaman({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3), // Latar belakang krem
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black54),
          onPressed: () {}, // Fungsi drawer
        ),
        actions: [
          // Header Profil
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selamat datang,", style: TextStyle(fontSize: 10, color: Colors.black)),
                    Text("Admin", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.orange.shade400,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Aplikasi
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF1A3D6B),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/logo.png', errorBuilder: (context, _, __) => const Icon(Icons.bolt, color: Colors.orange, size: 40)),
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "Keranjang Peminjaman",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Tampilan Keranjang Kosong
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 100,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "belum ada alat yang dipilih",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 100), // Memberi ruang di bawah agar posisi pas dengan gambar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}