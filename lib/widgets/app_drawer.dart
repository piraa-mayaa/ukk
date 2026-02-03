import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 180,
            color: const Color(0xFFFFC978),
            child: const Center(
              child: Text(
                'PEMINJAMAN ALAT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          _item(Icons.dashboard, 'Dashboard'),
          _item(Icons.inventory, 'Data alat'),
          _item(Icons.category, 'Kategori'),
          _item(Icons.person, 'Data user'),
          _item(Icons.assignment, 'Peminjaman'),
          _item(Icons.assignment_return, 'Pengembalian'),
          _item(Icons.history, 'Log Aktivitas'),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {},
    );
  }
}
