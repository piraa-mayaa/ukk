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
        centerTitle: false,
        title: const Text(
          'Data Alat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
                Text(
                  'Admin',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 6),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
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
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
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
                    kondisi: 'Alat Ukur',
                    unit: 1,
                    image: 'assets/alat/oscilloscope.png',
                  ),
                  AlatCard(
                    nama: 'Tang Amper',
                    kondisi: 'Alat Ukur',
                    unit: 1,
                    image: 'assets/alat/Tang_Amper.png',
                  ),
                  AlatCard(
                    nama: 'Multimeter',
                    kondisi: 'Alat Ukur',
                    unit: 1,
                    image: 'assets/alat/Multimeter.png',
                  ),
                  AlatCard(
                    nama: 'Power Supply',
                    kondisi: 'Alat Listrik',
                    unit: 2,
                    image: 'assets/alat/Power_Supply.png',
                  ),
                  AlatCard(
                    nama: 'Generator Trainer',
                    kondisi: 'Alat Mesin',
                    unit: 2,
                    image: 'assets/alat/Generator_Trainer.png',
                  ),
                  AlatCard(
                    nama: 'PLC Trainer',
                    kondisi: 'Alat Kontrol',
                    unit: 4,
                    image: 'assets/alat/PLC_Trainer.png',
                  ),
                  AlatCard(
                    nama: 'Voltage Regulator',
                    kondisi: 'Alat Listrik',
                    unit: 3,
                    image: 'assets/alat/Voltage_Regulator.png',
                  ),
                  AlatCard(
                    nama: 'Frequency Meter',
                    kondisi: 'Alat Ukur',
                    unit: 1,
                    image: 'assets/alat/Frequency_Meter.png',
                  ),
                  AlatCard(
                    nama: 'Thermometer Digital',
                    kondisi: 'Alat Pendukung',
                    unit: 7,
                    image: 'assets/alat/Thermometer_Digital.png',
                  ),
                  AlatCard(
                    nama: 'Pressure Gauge',
                    kondisi: 'Alat Pendukung',
                    unit: 5,
                    image: 'assets/alat/Pressure_Gauge.png',
                  ),
                  AlatCard(
                    nama: 'Relay Proteksi',
                    kondisi: 'Alat Listrik',
                    unit: 5,
                    image: 'assets/alat/Relay_Proteksi.png',
                  ),
                  AlatCard(
                    nama: 'Motor Induksi',
                    kondisi: 'Alat Mesin',
                    unit: 6,
                    image: 'assets/alat/Motor_Induksi.png',
                  ),
                  AlatCard(
                    nama: 'Inverter',
                    kondisi: 'Alat Kontrol',
                    unit: 4,
                    image: 'assets/alat/Inverter.png',
                  ),
                  AlatCard(
                    nama: 'Sensor Suhu',
                    kondisi: 'Alat Pendukung',
                    unit: 7,
                    image: 'assets/alat/Sensor_Suhu.png',
                  ),
                  AlatCard(
                    nama: 'Compressor Mini',
                    kondisi: 'Alat Pendukung',
                    unit: 8,
                    image: 'assets/alat/Compressor_Mini.png',
                  ),
                  AlatCard(
                    nama: 'Digital Tester',
                    kondisi: 'Alat Ukur',
                    unit: 1,
                    image: 'assets/alat/Digital_Tester.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
