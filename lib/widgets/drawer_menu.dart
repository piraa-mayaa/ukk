import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onDataUserTap;

  const DrawerMenu({super.key, required this.onDataUserTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            color: const Color(0xFFFFD180),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 35),
                ),
                SizedBox(height: 10),
                Text('PEMINJAMAN ALAT',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _item(Icons.grid_view, 'Dashboard', () => Navigator.pop(context)),
          _item(Icons.people, 'Data user', onDataUserTap),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          )
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
