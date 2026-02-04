import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF9D59B),
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final supabase = Supabase.instance.client;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alatController = TextEditingController();

  DateTime? _tanggalPinjam;
  String _status = 'Dipinjam';

  void _showTambahPeminjamanBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8E1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Tambah Peminjaman',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: _namaController,
                    decoration: _input('Nama Peminjam'),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _alatController,
                    decoration: _input('Nama Alat'),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => _tanggalPinjam = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _box(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _tanggalPinjam == null
                                ? 'Pilih Tanggal'
                                : DateFormat('yyyy-MM-dd').format(_tanggalPinjam!),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _input('Status'),
                    items: const [
                      DropdownMenuItem(value: 'Dipinjam', child: Text('Dipinjam')),
                      DropdownMenuItem(value: 'Menunggu', child: Text('Menunggu')),
                      DropdownMenuItem(value: 'Dikembalikan', child: Text('Dikembalikan')),
                    ],
                    onChanged: (val) => _status = val!,
                  ),

                  const Spacer(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      onPressed: _simpanKeSupabase,
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _simpanKeSupabase() async {
    if (_namaController.text.isEmpty ||
        _alatController.text.isEmpty ||
        _tanggalPinjam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data')),
      );
      return;
    }

    await supabase.from('peminjaman').insert({
      'nama': _namaController.text,
      'alat': _alatController.text,
      'tanggal_pinjam': _tanggalPinjam!.toIso8601String(),
      'status': _status,
    });

    _namaController.clear();
    _alatController.clear();
    _tanggalPinjam = null;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil disimpan ke Supabase')),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahPeminjamanBottomSheet,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Dashboard Admin'),
      ),
    );
  }
}
