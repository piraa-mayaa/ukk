import 'package:flutter/material.dart';

class KategoriCard extends StatelessWidget {
  final String nama;
  final String keterangan;
  final VoidCallback? onEdit;
  // final VoidCallback? onDelete; // bisa ditambah nanti

  const KategoriCard({
    super.key,
    required this.nama,
    required this.keterangan,
    this.onEdit,
    // this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    keterangan,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: onEdit,
                ),
                // IconButton(
                //   icon: const Icon(Icons.delete_outline, color: Colors.red),
                //   onPressed: onDelete,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}