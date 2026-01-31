import 'package:flutter/material.dart';

class AlatCard extends StatelessWidget {
  final String nama;
  final String kondisi;
  final int stok;
  final String image;

  const AlatCard({
    super.key,
    required this.nama,
    required this.kondisi,
    required this.stok,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // ================= IMAGE =================
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3DC),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(image, fit: BoxFit.contain),
          ),

          const SizedBox(width: 12),

          // ================= INFO =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kondisi : $kondisi',
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  'Stok : $stok',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),

          // ================= ACTION =================
          Column(
            children: [
              _iconBtn(Icons.edit, Colors.green),
              const SizedBox(height: 6),
              _iconBtn(Icons.delete, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}
