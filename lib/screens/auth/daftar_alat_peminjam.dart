import 'package:flutter/material.dart';
import 'persetujuan_peminjaman.dart';

class DaftarAlatPeminjam extends StatelessWidget {
  const DaftarAlatPeminjam({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFC97C),
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/logo.png',
                width: 22,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Peminjaman Alat',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selamat datang,',
                          style: TextStyle(fontSize: 10)),
                      Text('Admin',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Text('Peminjam',
                          style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                SizedBox(width: 6),
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
              ],
            ),
          )
        ],
      ),

      // ================= BODY =================
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'Daftar Alat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

        // LIST ALAT LENGKAP Sesuai Gambar
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: const [
                AlatCard(
                  nama: 'Oscilloscope',
                  kategori: 'Alat Ukur',
                  tersedia: '10 Unit',
                  gambar: 'assets/alat/oscilloscope.png',
                ),
                AlatCard(
                  nama: 'Tang Amper',
                  kategori: 'Alat Ukur',
                  tersedia: '1 Unit',
                  gambar: 'assets/alat/Tang_Amper.png',
                ),
                AlatCard(
                  nama: 'Multimeter',
                  kategori: 'Alat Ukur',
                  tersedia: '1 Unit',
                  gambar: 'assets/alat/Multimeter.png',
                ),
                AlatCard(
                  nama: 'Power Supply',
                  kategori: 'Alat Listrik',
                  tersedia: '2 Unit',
                  gambar: 'assets/alat/Power_Supply.png',
                ),
                AlatCard(
                  nama: 'Generator Trainer',
                  kategori: 'Alat Mesin',
                  tersedia: '2 Unit',
                  gambar: 'assets/alat/Generator_Trainer.png',
                ),
                AlatCard(
                  nama: 'PLC Trainer',
                  kategori: 'Alat Kontrol',
                  tersedia: '4 Unit',
                  gambar: 'assets/alat/PLC_Trainer.png',
                ),
                AlatCard(
                  nama: 'Voltage Regulator',
                  kategori: 'Alat Listrik',
                  tersedia: '8 Unit',
                  gambar: 'assets/alat/Voltage_Regulator.png',
                ),
                AlatCard(
                  nama: 'Frequency Meter',
                  kategori: 'Alat Ukur',
                  tersedia: '1 Unit',
                  gambar: 'assets/alat/Frequency_Meter.png',
                ),
                AlatCard(
                  nama: 'Thermometer Digital',
                  kategori: 'Alat Pendukung',
                  tersedia: '7 Unit',
                  gambar: 'assets/alat/Thermometer_Digital.png',
                ),
                AlatCard(
                  nama: 'Pressure Gauge',
                  kategori: 'Alat Pendukung',
                  tersedia: '5 Unit',
                  gambar: 'assets/alat/Pressure_Gauge.png',
                ),
                AlatCard(
                  nama: 'Relay Proteksi',
                  kategori: 'Alat Listrik',
                  tersedia: '5 Unit',
                  gambar: 'assets/alat/Relay_Proteksi.png',
                ),
                AlatCard(
                  nama: 'Motor Induksi',
                  kategori: 'Alat Mesin',
                  tersedia: '3 Unit',
                  gambar: 'assets/alat/Motor_Induksi.png',
                ),
                AlatCard(
                  nama: 'Inverter',
                  kategori: 'Alat Kontrol',
                  tersedia: '4 Unit',
                  gambar: 'assets/alat/Inverter.png',
                ),
                AlatCard(
                  nama: 'Sensor Suhu',
                  kategori: 'Alat Pendukung',
                  tersedia: '7 Unit',
                  gambar: 'assets/alat/Sensor_Suhu.png',
                ),
                AlatCard(
                  nama: 'Compressor Mini',
                  kategori: 'Alat Pendukung',
                  tersedia: '8 Unit',
                  gambar: 'assets/alat/Compressor_Mini.png',
                ),
                AlatCard(
                  nama: 'Digital Tester',
                  kategori: 'Alat Ukur',
                  tersedia: '10 Unit',
                  gambar: 'assets/alat/Digital_Tester.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= CARD ALAT =================
class AlatCard extends StatelessWidget {
  final String nama;
  final String kategori;
  final String tersedia;
  final String gambar;

  const AlatCard({
    super.key,
    required this.nama,
    required this.kategori,
    required this.tersedia,
    required this.gambar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1DF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.asset(
            gambar,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kategori: $kategori',
                  style: const TextStyle(
                      color: Colors.green, fontSize: 12),
                ),
                Text(
                  'Tersedia: $tersedia',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PersetujuanPeminjaman(namaAlat: nama),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC08A),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'pinjam',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
