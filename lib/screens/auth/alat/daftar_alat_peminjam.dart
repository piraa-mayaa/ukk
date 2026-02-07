import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/alat_model_api.dart';
import '../../../services/service_alat.dart';
import '../../../services/service_kategori.dart';

class DaftarAlatPeminjam extends StatefulWidget {
  const DaftarAlatPeminjam({super.key});

  @override
  State<DaftarAlatPeminjam> createState() => _DaftarAlatPeminjamState();
}

class _DaftarAlatPeminjamState extends State<DaftarAlatPeminjam> {
  final ServiceAlat _serviceAlat = ServiceAlat();
  final ServiceKategori _serviceKategori = ServiceKategori();
  String _searchQuery = '';
  int? _selectedKategori;
  List<int> _selectedAlatIds = []; // Keranjang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Daftar Alat Tersedia'),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        actions: [
          // Keranjang badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/keranjang',
                      arguments: _selectedAlatIds);
                },
              ),
              if (_selectedAlatIds.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_selectedAlatIds.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari alat...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFF8E1),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 12),
                // Category Filter
                FutureBuilder(
                  future: _serviceKategori.getAllKategori(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();

                    final kategoris = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // All kategori
                          ChoiceChip(
                            label: const Text('Semua'),
                            selected: _selectedKategori == null,
                            onSelected: (selected) {
                              setState(() => _selectedKategori = null);
                            },
                            selectedColor: const Color(0xFFFF9800),
                            labelStyle: TextStyle(
                              color: _selectedKategori == null
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Kategori chips
                          ...kategoris.map((kat) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(kat.nama),
                                  selected: _selectedKategori == kat.id,
                                  onSelected: (selected) {
                                    setState(() => _selectedKategori =
                                        selected ? kat.id : null);
                                  },
                                  selectedColor: const Color(0xFFFF9800),
                                  labelStyle: TextStyle(
                                    color: _selectedKategori == kat.id
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Alat Grid
          Expanded(
            child: FutureBuilder<List<AlatModel>>(
              future: _fetchAlat(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final alats = snapshot.data ?? [];

                if (alats.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada alat tersedia',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: alats.length,
                  itemBuilder: (context, index) {
                    final alat = alats[index];
                    final isSelected = _selectedAlatIds.contains(alat.id);

                    return _buildAlatCard(alat, isSelected);
                  },
                );
              },
            ),
          ),

          // Submit Button (fixed at bottom)
          if (_selectedAlatIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/keranjang',
                      arguments: _selectedAlatIds);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Ajukan Peminjaman (${_selectedAlatIds.length} alat)',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlatCard(AlatModel alat, bool isSelected) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: isSelected ? 8 : 2,
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedAlatIds.remove(alat.id);
            } else {
              _selectedAlatIds.add(alat.id);
            }
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: alat.foto != null && alat.foto!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: alat.foto!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.devices, size: 50),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.devices, size: 50),
                          ),
                  ),
                ),
                // Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alat.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alat.kode,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                alat.kondisi ?? 'Baik',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFFFF9800),
                                size: 24,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Selection overlay
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFF9800),
                      width: 3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<List<AlatModel>> _fetchAlat() async {
    // Get all alat with status 'tersedia'
    final alats = await _serviceAlat.getAlats();

    // Filter by status tersedia
    var filtered = alats.where((alat) => alat.status == 'tersedia').toList();

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((alat) {
        final nama = alat.nama.toLowerCase();
        final kode = alat.kode.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return nama.contains(query) || kode.contains(query);
      }).toList();
    }

    // Apply kategori filter
    if (_selectedKategori != null) {
      filtered = filtered
          .where((alat) => alat.idKategori == _selectedKategori)
          .toList();
    }

    return filtered;
  }
}
