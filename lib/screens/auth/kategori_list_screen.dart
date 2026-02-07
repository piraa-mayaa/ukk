import 'package:flutter/material.dart';
import '../../widgets/responsive_layout.dart';
import 'package:ukk/models/kategori_model.dart';
import 'package:ukk/services/service_kategori.dart';
import 'package:ukk/widgets/widgets.dart';
import './kategori_form_screen.dart';

class KategoriListScreen extends StatefulWidget {
  const KategoriListScreen({super.key});

  @override
  State<KategoriListScreen> createState() => _KategoriListScreenState();
}

class _KategoriListScreenState extends State<KategoriListScreen> {
  final ServiceKategori _service = ServiceKategori();
  late Future<List<Map<String, dynamic>>> _future;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allKategori = [];
  List<Map<String, dynamic>> _filteredKategori = [];

  @override
  void initState() {
    super.initState();
    _refresh();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _future = _service.getKategoriWithAlatCount().then((data) {
        _allKategori = data;
        _filteredKategori = data;
        return data;
      });
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() => _filteredKategori = _allKategori);
    } else {
      setState(() {
        _filteredKategori = _allKategori.where((item) {
          final kategori = item['kategori'] as KategoriModel;
          return kategori.nama.toLowerCase().contains(query) ||
              (kategori.keterangan?.toLowerCase().contains(query) ?? false);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9D59B),
        elevation: 0,
        centerTitle: Responsive.isMobile(context),
        title: const Text(
          'Kelola Data Kategori',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (!Responsive.isMobile(context))
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text(
                    'Administrator',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.person,
                      size: 16,
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
            // ================= SEARCH & ADD =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari nama atau keterangan...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color(0xFFFFEBCB),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () async {
                          final created =
                              await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => const KategoriFormScreen(),
                            ),
                          );
                          if (created == true && mounted) {
                            _refresh();
                          }
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ================= LIST =================
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refresh,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  final list = _filteredKategori;
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'Tidak ditemukan kategori dengan kata kunci "${_searchController.text}"'
                                : 'Belum ada data kategori.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return Responsive(
                    mobile: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: list.length,
                      itemBuilder: (context, i) => _buildCard(list[i]),
                    ),
                    tablet: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, i) => _buildCard(list[i]),
                    ),
                    desktop: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, i) => _buildCard(list[i]),
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

  Widget _buildCard(Map<String, dynamic> item) {
    final kategori = item['kategori'] as KategoriModel;
    final alatCount = item['alat_count'] as int;

    return KategoriCard(
      nama: kategori.nama,
      keterangan: kategori.keterangan ?? '',
      jumlahAlat: alatCount,
      onEdit: () async {
        final updated = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => KategoriFormScreen(kategori: kategori),
          ),
        );
        if (updated == true && mounted) {
          _refresh();
        }
      },
      onDelete: () async {
        if (alatCount > 0) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Kategori ini digunakan oleh $alatCount alat. Hapus alat terlebih dahulu.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Hapus Kategori'),
            content: Text('Yakin ingin menghapus kategori "${kategori.nama}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (ok == true && mounted) {
          final success = await _service.deleteKategori(kategori.id);
          if (mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kategori berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
              _refresh();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gagal menghapus kategori'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      },
      onTap: () {},
    );
  }
}
