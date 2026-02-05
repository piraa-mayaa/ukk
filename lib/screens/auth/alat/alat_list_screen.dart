import 'package:flutter/material.dart';
import 'package:ukk/widgets/widgets.dart';
import 'package:ukk/services/supabase_service.dart';
import 'package:ukk/models/alat_model_api.dart';
import 'package:ukk/screens/auth/alat/alat_form_screen.dart';

final _supabase = SupabaseService();

class AlatList extends StatefulWidget {
  const AlatList({super.key});

  @override
  State<AlatList> createState() => _AlatListState();
}

class _AlatListState extends State<AlatList> {
  late Future<List<AlatModel>> _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _future = _supabase.getAlats();
    });
  }

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
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      final created = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlatFormScreen(),
                        ),
                      );
                      if (created == true) _refresh();
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),

            // ================= LIST (dynamic from Supabase) =================
            Expanded(
              child: FutureBuilder<List<AlatModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final list = snapshot.data ?? [];
                  if (list.isEmpty) {
                    return const Center(child: Text('Tidak ada data alat'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final a = list[i];
                      return AlatCard(
                        nama: a.nama,
                        kondisi: a.kondisi ?? '-',
                        unit: 1,
                        image: 'assets/alat/placeholder.png',
                        imageUrl: a.fotoUrl,
                        onEdit: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AlatFormScreen(alat: a),
                            ),
                          );
                          if (updated == true) _refresh();
                        },
                        onDelete: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus alat'),
                              content:
                                  const Text('Yakin ingin menghapus alat ini?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Hapus')),
                              ],
                            ),
                          );
                          if (ok == true) {
                            final success = await _supabase.deleteAlat(a.id);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Berhasil dihapus')));
                              _refresh();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Gagal menghapus')));
                            }
                          }
                        },
                      );
                    },
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
