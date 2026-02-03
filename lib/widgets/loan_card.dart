import 'package:flutter/material.dart';

class LoanCard extends StatelessWidget {
  final String name;
  final String tool;
  final String date;
  final String status;
  final VoidCallback? onEdit;   // callback untuk tombol Edit
  final VoidCallback? onDelete; // callback untuk tombol Hapus

  const LoanCard({
    super.key,
    required this.name,
    required this.tool,
    required this.date,
    required this.status,
    this.onEdit,
    this.onDelete,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'dipinjam':
        return Colors.green;
      case 'menunggu':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      case 'dikembalikan':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'dipinjam':
        return Icons.check_circle;
      case 'menunggu':
        return Icons.hourglass_empty;
      case 'ditolak':
        return Icons.cancel;
      case 'dikembalikan':
        return Icons.keyboard_return;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Peminjam
          Row(
            children: [
              Icon(Icons.person_outline, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Peminjam: ',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Nama Alat
          Row(
            children: [
              Icon(Icons.build_outlined, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Nama Alat: ',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              Expanded(
                child: Text(
                  tool,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Tanggal Pinjam
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Tanggal pinjam: ',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Status dengan ikon
          Row(
            children: [
              Icon(
                _getStatusIcon(),
                size: 18,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Status: ',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 18, color: Color(0xFFFF9800)),
                label: const Text(
                  'Edit',
                  style: TextStyle(color: Color(0xFFFF9800)),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                label: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}