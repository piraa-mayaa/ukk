import 'package:flutter/material.dart';

class InformasiPeminjaman extends StatelessWidget {
  const InformasiPeminjaman({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3), // Warna latar belakang sesuai desain
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.menu, color: Colors.black54),
        actions: [
          // Widget Profil Header
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
          // Logo Aplikasi Tengah
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF1A3D6B), // Warna biru logo
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/logo.png', // Pastikan logo tersedia di assets
                width: 60,
                height: 60,
                errorBuilder: (context, _, __) => const Icon(Icons.bolt, color: Colors.orange, size: 50),
              ),
            ),
          ),
          
          // Judul Halaman dan Ikon Keranjang
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Informasi Peminjaman",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.shopping_basket_rounded, color: Colors.orange.shade300, size: 35),
              ],
            ),
          ),

          // Daftar Kartu Riwayat
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                StatusCard(
                  namaAlat: "Multimeter",
                  kodeAlat: "AL-006",
                  tglPinjam: "22Jan 2026",
                  tglKembali: "23 Jan 2026",
                  status: "Dikembalikan",
                  statusColor: Color(0xFFD1D1D1), // Abu-abu
                ),
                StatusCard(
                  namaAlat: "Tang Amper",
                  kodeAlat: "AL-006",
                  tglPinjam: "22Jan 2026",
                  tglKembali: "23 Jan 2026",
                  status: "Menunggu",
                  statusColor: Color(0xFFFFD591), // Oranye
                ),
                StatusCard(
                  namaAlat: "Inverter",
                  kodeAlat: "AL-006",
                  tglPinjam: "22Jan 2026",
                  tglKembali: "23 Jan 2026",
                  status: "Ditolak",
                  statusColor: Color(0xFFFFA0A0), // Merah
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String namaAlat;
  final String kodeAlat;
  final String tglPinjam;
  final String tglKembali;
  final String status;
  final Color statusColor;

  const StatusCard({
    super.key,
    required this.namaAlat,
    required this.kodeAlat,
    required this.tglPinjam,
    required this.tglKembali,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                namaAlat,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Kode Alat : $kodeAlat",
                style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text("Tgl Pinjam :   ", style: TextStyle(fontSize: 16)),
                  Text(tglPinjam, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text("Tgl Kembali : ", style: TextStyle(fontSize: 16)),
                  Text(
                    tglKembali,
                    style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          // Badge Status Pojok Kanan Atas
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))
                ]
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}