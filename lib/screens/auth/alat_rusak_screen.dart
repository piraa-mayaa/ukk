import 'package:flutter/material.dart';

class AlatRusakScreen extends StatefulWidget {
  const AlatRusakScreen({super.key});

  @override
  State<AlatRusakScreen> createState() => _AlatRusakScreenState();
}

class _AlatRusakScreenState extends State<AlatRusakScreen> {
  String _selectedRole = 'Peminjam';

  // Dummy data alat rusak (ganti dengan data real dari backend nanti)
  final List<Map<String, dynamic>> _alatRusak = [
    {
      'nama': 'Power Supply',
      'gambar': 'https://images.unsplash.com/photo-1581092160560-1c1e428e9d65?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'nama': 'Frequency Meter',
      'gambar': 'https://images.unsplash.com/photo-1581092160560-1c1e428e9d65?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'nama': 'Inverter',
      'gambar': 'https://images.unsplash.com/photo-1581092160560-1c1e428e9d65?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'nama': 'Motor Induksi',
      'gambar': 'https://images.unsplash.com/photo-1581092160560-1c1e428e9d65?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'nama': 'Compressor Mini',
      'gambar': 'https://images.unsplash.com/photo-1581092160560-1c1e428e9d65?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Column(
          children: [
            // Header (sama seperti halaman lain)
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

                      // Notifikasi + Role switcher
                      const Icon(Icons.notifications, color: Colors.white),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedRole,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                          DropdownMenuItem(value: 'Petugas', child: Text('Petugas')),
                          DropdownMenuItem(value: 'Peminjam', child: Text('Peminjam')),
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
                'Alat Rusak',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // List alat rusak
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _alatRusak.length,
                itemBuilder: (context, index) {
                  final alat = _alatRusak[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar alat
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              alat['gambar'],
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 160,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Nama alat
                          Text(
                            alat['nama'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Alat rusak',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
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