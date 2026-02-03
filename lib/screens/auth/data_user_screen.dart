import 'package:flutter/material.dart';

class DataUserScreen extends StatefulWidget {
  const DataUserScreen({super.key});

  @override
  State<DataUserScreen> createState() => _DataUserScreenState();
}

class _DataUserScreenState extends State<DataUserScreen> {
  final List<Map<String, dynamic>> dummyUsers = [
    {'initial': 'AU', 'name': 'Admin Utama', 'role': 'Admin', 'color': Colors.blue},
    {'initial': 'PL', 'name': 'Pelapor 1', 'role': 'Pelapor', 'color': Colors.green},
    {'initial': 'PL', 'name': 'Pelapor 2', 'role': 'Pelapor', 'color': Colors.green},
    {'initial': 'AS', 'name': 'Andi Saputra', 'role': 'Operator', 'color': Colors.purple},
    {'initial': 'BS', 'name': 'Budi Santoso', 'role': 'Verifikator', 'color': Colors.teal},
    {'initial': 'CL', 'name': 'Citra Lestari', 'role': 'Admin', 'color': Colors.orange},
    {'initial': 'DP', 'name': 'Deni Pratama', 'role': 'Pelapor', 'color': Colors.cyan},
    {'initial': 'BP', 'name': 'Bila Putri', 'role': 'Operator', 'color': Colors.indigo},
    {'initial': 'FH', 'name': 'Fajar Hidayat', 'role': 'Verifikator', 'color': Colors.amber},
    {'initial': 'GM', 'name': 'Gita Maharani', 'role': 'Pelapor', 'color': Colors.lime},
    {'initial': 'HW', 'name': 'Hadi Wijaya', 'role': 'Admin', 'color': Colors.deepPurple},
  ];

  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Daftar User (selalu tampil di layout lebar)
            if (isWide)
              Container(
                width: 320,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  border: Border(right: BorderSide(color: Colors.orange.shade200)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari user...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dummyUsers.length,
                        itemBuilder: (context, index) {
                          final user = dummyUsers[index];
                          final isSelected = selectedUser == user['name'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: Material(
                              color: isSelected ? Colors.orange.shade100 : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: user['color'].withOpacity(0.2),
                                  child: Text(
                                    user['initial'],
                                    style: TextStyle(
                                      color: user['color'],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  user['name'],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.orange.shade900 : Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  user['role'],
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit_square, size: 20),
                                  color: Colors.orange,
                                  onPressed: () {
                                    setState(() => selectedUser = user['name']);
                                  },
                                ),
                                onTap: () {
                                  setState(() => selectedUser = user['name']);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            // Right: Form detail / pengelolaan user
            Expanded(
              child: _buildUserFormArea(isWide),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserFormArea(bool isWide) {
    return Container(
      color: const Color(0xFFFFF8E1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pengelolaan User',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              if (!isWide)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Buka drawer di mobile
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Tambah User'),
                onPressed: () {
                  setState(() => selectedUser = null); // reset form untuk tambah baru
                },
              ),
            ],
          ),
          const SizedBox(height: 28),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedUser == null ? 'Tambah User Baru' : 'Edit User: $selectedUser',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),

                  _buildTextField('Nama Lengkap', 'Masukkan nama lengkap'),
                  const SizedBox(height: 20),

                  _buildTextField('Username / NIP', 'contoh: admin123 / 1987654321'),
                  const SizedBox(height: 20),

                  _buildTextField('Email', 'email@domain.com', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Jabatan / Role',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    value: 'Admin',
                    items: const [
                      DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                      DropdownMenuItem(value: 'Operator', child: Text('Operator')),
                      DropdownMenuItem(value: 'Verifikator', child: Text('Verifikator')),
                      DropdownMenuItem(value: 'Pelapor', child: Text('Pelapor')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade800,
                        ),
                        onPressed: () {},
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        ),
                        onPressed: () {
                          // TODO: simpan data
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User berhasil disimpan')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {TextInputType? keyboardType}) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}