import 'package:flutter/material.dart';

class AlatCard extends StatelessWidget {
  const AlatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: const Text("Oscilloscope"),
        subtitle: const Text("Status: Tersedia"),
        trailing: Chip(
          label: const Text("Alat Ukur"),
          backgroundColor: Colors.blue.shade50,
        ),
      ),
    );
  }
}
