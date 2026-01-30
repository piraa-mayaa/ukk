import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerTitle(),
            const SizedBox(height: 16),
            _statisticCards(),
            const SizedBox(height: 16),
            _searchAndAdd(),
            const SizedBox(height: 16),
            _latestLoanList(),
          ],
        ),
      ),
    );
  }

  // ================= APP BAR =================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFFC97C),
      elevation: 0,
      leading: const Icon(Icons.menu, color: Colors.black),
      title: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.school, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Selamat datang,\nAdmin',
                    style: TextStyle(fontSize: 12),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _headerTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'PEMINJAMAN ALAT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Teknik Pembangkit',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // ================= STATISTIC =================
  Widget _statisticCards() {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            color: Colors.green,
            icon: Icons.check_circle,
            value: '58',
            label: 'Alat tersedia',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            color: Colors.orange,
            icon: Icons.autorenew,
            value: '4',
            label: 'Sedang dipinjam',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            color: Colors.red,
            icon: Icons.build,
            value: '5',
            label: 'Alat rusak',
          ),
        ),
      ],
    );
  }

  // ================= SEARCH =================
  Widget _searchAndAdd() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFFE0B2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundColor: const Color(0xFFFFC97C),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // ================= LIST =================
  Widget _latestLoanList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peminjaman Terbaru',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            5,
            (index) => const _LoanCard(),
          ),
        ],
      ),
    );
  }
}

// ================= STAT CARD =================
class _StatCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ================= LOAN CARD =================
class _LoanCard extends StatelessWidget {
  const _LoanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Peminjam', 'Andi Saputra'),
          _row('Nama Alat', 'Oscilloscope'),
          _row('Tanggal pinjam', '24 April 2024'),
          _row('Status', 'Dipinjam', status: true),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionButton('Setujui', Colors.green),
              const SizedBox(width: 8),
              _actionButton('Tolak', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value, {bool status = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(title)),
          Text(
            value,
            style: TextStyle(
              color: status ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(70, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {},
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}