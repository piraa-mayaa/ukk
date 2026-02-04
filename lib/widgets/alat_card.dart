import 'package:flutter/material.dart';

class AlatCard extends StatelessWidget {
  final String nama;
  final String kondisi;
  final int unit;
  final String image;

  const AlatCard({
    super.key,
    required this.nama,
    required this.kondisi,
    required this.unit,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Buka halaman detail alat (misal Navigator.push ke DetailAlatScreen)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detail alat: $nama')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar alat
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3DC),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Info alat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kondisi: $kondisi',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Unit: $unit',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Tombol aksi (edit & delete)
            Column(
              children: [
                _actionButton(Icons.edit, Colors.green, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Edit $nama')),
                  );
                }),
                const SizedBox(height: 8),
                _actionButton(Icons.delete, Colors.red, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hapus $nama')),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }
}