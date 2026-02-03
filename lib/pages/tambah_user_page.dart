import 'package:flutter/material.dart';

class TambahUserPage extends StatelessWidget {
  const TambahUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah User')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, child: Text('AU')),
            const SizedBox(height: 20),
            _input('Nama'),
            _input('Username'),
            _input('Role'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Simpan'))
          ],
        ),
      ),
    );
  }

  Widget _input(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
