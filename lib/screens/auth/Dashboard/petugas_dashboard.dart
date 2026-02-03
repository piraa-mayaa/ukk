import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  String _selectedRole = 'Petugas';

  // Dummy statistik
  final Map<String, dynamic> stats = {
    'tersedia': 58,
    'dipinjam': 4,
    'rusak': 5,
  };

  // Dummy daftar permintaan
  final List<Map<String, dynamic>> pendingRequests = [
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'menunggu',
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'disetujui',
    },
    {
      'nama': 'Citra Lestari',
      'inisial': 'CL',
      'kelas': '12',
      'alat': 'Tang Amper',
      'tanggal': DateTime(2026, 1, 12),
      'status': 'ditolak',
      'alasan': 'Alat sedang diperbaiki',
    },
  ];

  // Form fields
  final _namaSiswaController = TextEditingController();
  final _namaAlatController = TextEditingController();
  String? _selectedKelas;
  TimeOfDay? _jamMulai;
  TimeOfDay? _jamSelesai;

  Future<void> _pickTime(bool isMulai) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        if (isMulai) _jamMulai = picked;
        if (!isMulai) _jamSelesai = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // cream/orange muda
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────
              Container(
                color: const Color(0xFFFF9800),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.build, color: Color(0xFFFF9800), size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PEMINJAMAN ALAT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Teknik Pembangkit',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedRole,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          underline: const SizedBox(),
                          items: ['Admin', 'Petugas'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() => _selectedRole = newValue);
                            }
                          },
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.waving_hand, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Selamat datang, $_selectedRole',
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Statistik
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatCard(
                          icon: Icons.check_circle_outline,
                          label: 'Alat tersedia',
                          value: stats['tersedia'],
                          color: Colors.green,
                        ),
                        _StatCard(
                          icon: Icons.swap_horiz,
                          label: 'Sedang dipinjam',
                          value: stats['dipinjam'],
                          color: Colors.orange,
                        ),
                        _StatCard(
                          icon: Icons.report_problem_outlined,
                          label: 'Alat rusak',
                          value: stats['rusak'],
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Permintaan Peminjaman',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),

                    ...pendingRequests.map((req) => _buildRequestCard(req, dateFormat)),

                    const SizedBox(height: 32),

                    // Form Ajukan Peminjaman
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Ajukan Peminjaman Baru',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            TextField(
                              controller: _namaSiswaController,
                              decoration: _inputDeco('Nama Siswa'),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _namaAlatController,
                              decoration: _inputDeco('Nama Alat'),
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              value: _selectedKelas,
                              decoration: _inputDeco('Kelas'),
                              items: const [
                                DropdownMenuItem(value: '10', child: Text('10')),
                                DropdownMenuItem(value: '11', child: Text('11')),
                                DropdownMenuItem(value: '12', child: Text('12')),
                              ],
                              onChanged: (v) => setState(() => _selectedKelas = v),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(child: _timeField('Jam', true)),
                                const SizedBox(width: 16),
                                Expanded(child: _timeField('Selesai', false)),
                              ],
                            ),

                            const SizedBox(height: 32),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _resetForm(),
                                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: kirim ke backend
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Pengajuan berhasil dikirim')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9800),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  ),
                                  child: const Text('Simpan'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _StatCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color.withOpacity(0.9), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req, DateFormat dateFormat) {
    final status = req['status'] as String;
    Color cardColor = Colors.orange.shade50;
    Color accentColor = Colors.orange;
    String statusLabel = 'Menunggu Persetujuan';

    if (status == 'disetujui') {
      cardColor = Colors.green.shade50;
      accentColor = Colors.green;
      statusLabel = 'Disetujui';
    } else if (status == 'ditolak') {
      cardColor = Colors.red.shade50;
      accentColor = Colors.red;
      statusLabel = 'Ditolak';
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentColor.withOpacity(0.2),
                  child: Text(
                    req['inisial'],
                    style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req['nama'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${req['kelas']} • ${dateFormat.format(req['tanggal'])}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      req['alat'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: accentColor),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (status == 'menunggu')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {/* TODO tolak */},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Tolak'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {/* TODO setuju */},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Setuju'),
                  ),
                ],
              )
            else
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

            if (req['alasan'] != null) ...[
              const SizedBox(height: 12),
              Text(
                req['alasan'],
                style: TextStyle(color: Colors.red[700], fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _timeField(String label, bool isStart) {
    return GestureDetector(
      onTap: () => _pickTime(isStart),
      child: InputDecorator(
        decoration: _inputDeco(label),
        child: Text(
          isStart
              ? (_jamMulai?.format(context) ?? 'Pilih')
              : (_jamSelesai?.format(context) ?? 'Pilih'),
          style: TextStyle(
            color: (isStart ? _jamMulai : _jamSelesai) != null ? Colors.black87 : Colors.grey,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _resetForm() {
    _namaSiswaController.clear();
    _namaAlatController.clear();
    setState(() {
      _selectedKelas = null;
      _jamMulai = null;
      _jamSelesai = null;
    });
  }

  @override
  void dispose() {
    _namaSiswaController.dispose();
    _namaAlatController.dispose();
    super.dispose();
  }
}