import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/peminjaman_model.dart';
import '../../../services/service_peminjaman.dart';
import '../pengembalian/pengembalian_form.dart';

class PeminjamanListPetugas extends StatefulWidget {
  final int initialIndex;
  final bool isEmbedded;

  const PeminjamanListPetugas({
    super.key,
    this.initialIndex = 0,
    this.isEmbedded = false,
  });

  @override
  State<PeminjamanListPetugas> createState() => _PeminjamanListPetugasState();
}

class _PeminjamanListPetugasState extends State<PeminjamanListPetugas>
    with SingleTickerProviderStateMixin {
  final ServicePeminjaman _service = ServicePeminjaman();
  late TabController _tabController;

  List<PeminjamanModel> _allLoans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _service.getAllPeminjaman();
    if (mounted) {
      setState(() {
        _allLoans = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEmbedded) {
      return Column(
        children: [
          Container(
            color: const Color(0xFFFF9800),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Dipinjam'),
                Tab(text: 'Selesai'),
                Tab(text: 'Ditolak'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList('semua'),
                      _buildList('disetujui'),
                      _buildList('selesai'),
                      _buildList('ditolak'),
                    ],
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Dipinjam'),
            Tab(text: 'Selesai'),
            Tab(text: 'Ditolak'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList('semua'),
                _buildList('disetujui'), // Status 'disetujui' = Sedang dipinjam
                _buildList('selesai'),
                _buildList('ditolak'),
              ],
            ),
    );
  }

  Widget _buildList(String filterStatus) {
    final filtered = filterStatus == 'semua'
        ? _allLoans
        : _allLoans.where((p) => p.status == filterStatus).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return _buildCard(filtered[index]);
        },
      ),
    );
  }

  Widget _buildCard(PeminjamanModel loan) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final isDipinjam = loan.status == 'disetujui';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loan.user?.nama ?? 'User #${loan.idUser}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildStatusChip(loan.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Tgl Pinjam: ${dateFormat.format(loan.tanggalPinjam)}'),
            Text('Tgl Kembali: ${dateFormat.format(loan.tanggalKembali)}'),
            const SizedBox(height: 8),
            const Divider(),
            const Text(
              'Alat:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            ...?loan.details?.map((d) => Text('- ${d.namaAlat}')),
            if (isDipinjam) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToPengembalian(loan),
                  icon: const Icon(Icons.assignment_return),
                  label: const Text('Proses Pengembalian'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'menunggu':
        color = Colors.orange;
        label = 'Menunggu';
        break;
      case 'disetujui':
        color = Colors.blue;
        label = 'Dipinjam';
        break;
      case 'selesai':
        color = Colors.green;
        label = 'Selesai';
        break;
      case 'ditolak':
        color = Colors.red;
        label = 'Ditolak';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  void _navigateToPengembalian(PeminjamanModel loan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengembalianForm(peminjaman: loan),
      ),
    );

    if (result == true) {
      _loadData(); // Refresh if returned successfully
    }
  }
}
