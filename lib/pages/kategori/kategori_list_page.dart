import 'package:flutter/material.dart';
import 'dart:io';
import '../../widgets/widgets.dart';
import '../../services/service_kategori.dart';
import '../../models/kategori_model.dart';

// SOLUSI: Comment dulu import yang bermasalah, kita buat workaround
// import './kategori_form_screen.dart'; // DICOMMENT DULU

// Workaround: Buat placeholder class sementara
class KategoriFormScreen extends StatefulWidget {
  final KategoriModel? kategori;
  
  const KategoriFormScreen({Key? key, this.kategori}) : super(key: key);

  @override
  State<KategoriFormScreen> createState() => _KategoriFormScreenState();
}

class _KategoriFormScreenState extends State<KategoriFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kategori == null ? 'Tambah Kategori' : 'Edit Kategori'),
      ),
      body: const Center(
        child: Text('Form Kategori (Placeholder)'),
      ),
    );
  }
}

class KategoriListPage extends StatefulWidget {
  const KategoriListPage({Key? key}) : super(key: key);

  @override
  State<KategoriListPage> createState() => _KategoriListPageState();
}

class _KategoriListPageState extends State<KategoriListPage> {
  final ServiceKategori _service = ServiceKategori();
  final TextEditingController _searchController = TextEditingController();
  
  List<KategoriModel> _kategoriList = [];
  List<KategoriModel> _filteredList = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    print('🔄 KategoriListPage initState');
    
    // Debug: Cek apakah file ada
    _checkFiles();
    
    _loadKategori();
    _searchController.addListener(_onSearchChanged);
  }

  void _checkFiles() {
    print('📁 Checking files...');
    final currentDir = Directory.current.path;
    print('Current directory: $currentDir');
    
    final folderPath = 'lib/pages/kategori';
    final folder = Directory(folderPath);
    
    if (folder.existsSync()) {
      print('✅ Folder $folderPath exists');
      final files = folder.listSync();
      print('📄 Files in folder:');
      for (var file in files) {
        print('  - ${file.path.split('/').last}');
      }
    } else {
      print('❌ Folder $folderPath does NOT exist');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadKategori() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final data = await _service.getAllKategori();
      setState(() {
        _kategoriList = data;
        _filteredList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() => _filteredList = _kategoriList);
    } else {
      setState(() {
        _filteredList = _kategoriList.where((kategori) {
          return kategori.nama.toLowerCase().contains(query) ||
              (kategori.keterangan?.toLowerCase().contains(query) ?? false);
        }).toList();
      });
    }
  }

  Future<void> _deleteKategori(int id, String nama) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Yakin ingin menghapus kategori "$nama"?'),
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

    if (confirmed == true) {
      final success = await _service.deleteKategori(id);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kategori "$nama" berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
          _loadKategori();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus kategori. Kategori mungkin sedang digunakan.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3B3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC97C),
        elevation: 0,
        title: const Text(
          'Kategori',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _loadKategori,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari kategori...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFFFF1D6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    print('➕ Opening form...');
                    final created = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => const KategoriFormScreen(),
                      ),
                    );
                    if (created == true && mounted) {
                      _loadKategori();
                    }
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            const Text(
                              'Gagal memuat data',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _loadKategori,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : _filteredList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isNotEmpty
                                      ? 'Tidak ditemukan kategori dengan kata kunci "${_searchController.text}"'
                                      : 'Belum ada data kategori',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (_searchController.text.isNotEmpty)
                                  TextButton(
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                    child: const Text('Reset Pencarian'),
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final kategori = _filteredList[index];
                              return KategoriCard(
                                nama: kategori.nama,
                                keterangan: kategori.keterangan ?? 'Tidak ada keterangan',
                                jumlahAlat: 0,
                                onEdit: () async {
                                  final updated = await Navigator.of(context).push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => KategoriFormScreen(kategori: kategori),
                                    ),
                                  );
                                  if (updated == true && mounted) {
                                    _loadKategori();
                                  }
                                },
                                onDelete: () => _deleteKategori(kategori.id, kategori.nama),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}