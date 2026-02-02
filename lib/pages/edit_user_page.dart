import 'package:flutter/material.dart';

class EditUserPage extends StatelessWidget {
  final String nama;
  final String role;

  const EditUserPage({super.key, required this.nama, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 40, child: Text(nama[0])),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: nama,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Role',
                hintText: role,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Update'))
          ],
        ),
      ),
    );
  }
}
