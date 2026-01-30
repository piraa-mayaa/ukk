import 'package:flutter/material.dart';

class LoanCard extends StatelessWidget {
  final String name;
  final String tool;
  final String date;
  final String status;

  const LoanCard({
    super.key,
    required this.name,
    required this.tool,
    required this.date,
    required this.status,
  });

  Color getStatusColor() {
    if (status == 'Menunggu') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Peminjam : $name'),
          Text('Nama Alat : $tool'),
          Text('Tanggal pinjam : $date'),
          Row(
            children: [
              Text(
                'Status : ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                status,
                style: TextStyle(color: getStatusColor()),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Setujui'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Tolak',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
