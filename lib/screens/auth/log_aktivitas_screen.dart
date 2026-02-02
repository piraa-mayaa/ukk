import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogAktivitasScreen extends StatefulWidget {
  const LogAktivitasScreen({super.key});

  @override
  State<LogAktivitasScreen> createState() => _LogAktivitasScreenState();
}

class _LogAktivitasScreenState extends State<LogAktivitasScreen> {
  String _searchQuery = '';

  // Data dummy log aktivitas (bisa diganti dengan API nanti)
  final List<Map<String, dynamic>> _logList = [
    {
      'user': 'Admin',
      'tanggal': DateTime(2026, 1, 12),
      'aktivitas': 'Menambahkan 3 unit Tang amper',
      'tipe': 'Dibuat',
      'kategori': 'Alat',
    },
    {
      'user': 'Petugas',
      'tanggal': DateTime(2026, 1, 12),
      'aktivitas': 'Menambahkan 3 unit Tang amper',
      'tipe': 'Dibuat',
      'kategori': 'Alat',
    },
    // bisa tambah lebih banyak
    {
      'user': 'Admin',
      'tanggal': DateTime(2026, 1, 11),
      'aktivitas': 'Mengubah status Multimeter menjadi Rusak',
      'tipe': 'Diubah',
      'kategori': 'Alat',
    },
    {
      'user': 'Petugas',
      'tanggal': DateTime(2026, 1, 10),
      'aktivitas': 'Mencatat pengembalian Thermometer Digital',
      'tipe': 'Dibuat',
      'kategori': 'Pengembalian',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 960;

    final filteredLogs = _logList.where((log) {
      final query = _searchQuery.toLowerCase();
      return log['user'].toLowerCase().contains(query) ||
          log['aktivitas'].toLowerCase().contains(query) ||
          log['kategori'].toLowerCase().contains(query);
    }).toList();

    return Container(
      color: const Color(0xFFFFF8E1),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Log Aktivitas',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Search bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),

          // List log
          Expanded(
            child: filteredLogs.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada aktivitas yang ditemukan',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
                      final formattedDate = dateFormat.format(log['tanggal']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          log['user'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFC107).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      log['tipe'],
                                      style: const TextStyle(
                                        color: Color(0xFFFF9800),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                log['aktivitas'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    log['kategori'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
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
    );
  }
}