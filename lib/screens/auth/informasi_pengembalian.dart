import 'package:flutter/material.dart';

class InformasiPengembalian extends StatelessWidget {
  const InformasiPengembalian({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3), // Latar belakang krem sesuai desain
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Aplikasi
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A3D6B),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/logo.png',
                  width: 65,
                  height: 65,
                  errorBuilder: (context, _, __) => const Icon(Icons.bolt, color: Colors.orange, size: 55),
                ),
              ),
            ),
            
            const Text(
              "Informasi Pengembalian",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Daftar Kartu Pengembalian
            const PengembalianCard(
              namaAlat: "Tang Amper",
              kodeAlat: "AL-006",
              tglPinjam: "22Jan 2026",
              tglKembali: "23 Jan 2026",
              status: "Dipinjam",
              statusColor: Color(0xFFB4D3A2), // Hijau lembut
            ),
            const PengembalianCard(
              namaAlat: "Inverter",
              kodeAlat: "AL-006",
              tglPinjam: "22Jan 2026",
              tglKembali: "23 Jan 2026",
              status: "Terlambat",
              statusColor: Color(0xFFFFA0A0), // Merah muda
            ),
          ],
        ),
      ),
    );
  }
}

class PengembalianCard extends StatelessWidget {
  final String namaAlat;
  final String kodeAlat;
  final String tglPinjam;
  final String tglKembali;
  final String status;
  final Color statusColor;

  const PengembalianCard({
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaAlat,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Kode Alat : $kodeAlat",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text("Tgl Pinjam :   ", style: TextStyle(fontSize: 16)),
                      Text(tglPinjam, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 4),
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
              // Badge Status
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
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
          const SizedBox(height: 15),
          // Tombol Ajukan Pengembalian
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan logika pengajuan di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFCB144), // Oranye
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                "Ajukan Pengembalian",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}