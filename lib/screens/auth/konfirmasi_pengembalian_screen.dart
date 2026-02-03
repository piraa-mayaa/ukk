import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KonfirmasiPengembalianScreen extends StatefulWidget {
  const KonfirmasiPengembalianScreen({super.key});

  @override
  State<KonfirmasiPengembalianScreen> createState() => _KonfirmasiPengembalianScreenState();
}

class _KonfirmasiPengembalianScreenState extends State<KonfirmasiPengembalianScreen> {
  String _selectedRole = 'Petugas';

  // Dummy data pengembalian yang menunggu konfirmasi
  final List<Map<String, dynamic>> _pengembalianList = [
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFFFF9800),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Logo
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.build_circle, color: Color(0xFFFF9800), size: 32),
                      ),
                      const SizedBox(width: 12),

                      // Judul aplikasi
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PEMINJAMAN ALAT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Teknik Pembangkit',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      // Notifikasi + Role
                      const Icon(Icons.notifications, color: Colors.white),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedRole,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                          DropdownMenuItem(value: 'Petugas', child: Text('Petugas')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedRole = val);
                        },
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Greeting bubble
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.waving_hand, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Selamat datang, $_selectedRole',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Judul halaman
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: const Text(
                'Konfirmasi Pengembalian',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // List pengembalian
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _pengembalianList.length,
                itemBuilder: (context, index) {
                  final item = _pengembalianList[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Info peminjam
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.pink.withOpacity(0.2),
                                child: Text(
                                  item['inisial'],
                                  style: const TextStyle(
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['nama'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${item['kelas']} • ${dateFormat.format(item['tanggal'])}',
                                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Nama alat
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE0B2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['alat'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Color(0xFFFF9800),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Tombol Konfirmasi Pengembalian
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi Pengembalian'),
                                    content: Text(
                                      'Apakah Anda yakin ingin mengonfirmasi pengembalian "${item['alat']}" oleh ${item['nama']}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Pengembalian berhasil dikonfirmasi')),
                                          );
                                          // TODO: update status di backend / hapus dari list
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFF9800),
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Konfirmasi'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9800),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Konfirmasi Pengembalian'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}