import 'package:flutter/material.dart';
import '../../services/service_users.dart';
import '../../models/user_model.dart';

class DataUserScreen extends StatefulWidget {
  const DataUserScreen({super.key});

  @override
  State<DataUserScreen> createState() => _DataUserScreenState();
}

class _DataUserScreenState extends State<DataUserScreen> {
  // Data sesuai dengan tabel yang diberikan
  final List<Map<String, dynamic>> dummyUsers = [
    {
      'id': 1,
      'initial': 'AU',
      'name': 'Admin Utama',
      'role': 'admin',
      'username': 'admin',
      'password': 'admin123',
      'color': Colors.blue
    },
    {
      'id': 2,
      'initial': 'PL',
      'name': 'Petugas Lab 1',
      'role': 'petugas',
      'username': 'petugas1',
      'password': 'petugas123',
      'color': Colors.green
    },
    {
      'id': 3,
      'initial': 'PL',
      'name': 'Petugas Lab 2',
      'role': 'petugas',
      'username': 'petugas2',
      'password': 'petugas123',
      'color': Colors.green
    },
    {
      'id': 4,
      'initial': 'AS',
      'name': 'Andi Saputra',
      'role': 'peminjam',
      'username': 'andi',
      'password': 'andi123',
      'color': Colors.purple
    },
    {
      'id': 5,
      'initial': 'BS',
      'name': 'Budi Santoso',
      'role': 'peminjam',
      'username': 'budi',
      'password': 'budi123',
      'color': Colors.teal
    },
    {
      'id': 6,
      'initial': 'CL',
      'name': 'Citra Lestari',
      'role': 'peminjam',
      'username': 'citra',
      'password': 'citra123',
      'color': Colors.orange
    },
    {
      'id': 7,
      'initial': 'DP',
      'name': 'Deni Pratama',
      'role': 'peminjam',
      'username': 'deni',
      'password': 'deni123',
      'color': Colors.cyan
    },
    {
      'id': 8,
      'initial': 'EP',
      'name': 'Eka Putri',
      'role': 'peminjam',
      'username': 'eka',
      'password': 'eka123',
      'color': Colors.indigo
    },
    {
      'id': 9,
      'initial': 'FH',
      'name': 'Fajar Hidayat',
      'role': 'peminjam',
      'username': 'fajar',
      'password': 'fajar123',
      'color': Colors.amber
    },
    {
      'id': 10,
      'initial': 'GM',
      'name': 'Gita Maharani',
      'role': 'peminjam',
      'username': 'gita',
      'password': 'gita123',
      'color': Colors.lime
    },
    {
      'id': 11,
      'initial': 'HW',
      'name': 'Hadi Wijaya',
      'role': 'peminjam',
      'username': 'hadi',
      'password': 'hadi123',
      'color': Colors.deepPurple
    },
    {
      'id': 12,
      'initial': 'IP',
      'name': 'Indah Permata',
      'role': 'peminjam',
      'username': 'indah',
      'password': 'indah123',
      'color': Colors.pink
    },
    {
      'id': 13,
      'initial': 'JS',
      'name': 'Joko Santoso',
      'role': 'peminjam',
      'username': 'joko',
      'password': 'joko123',
      'color': Colors.brown
    },
    {
      'id': 14,
      'initial': 'KP',
      'name': 'Kevin Pratama',
      'role': 'peminjam',
      'username': 'kevin',
      'password': 'kevin123',
      'color': Colors.grey
    },
    {
      'id': 15,
      'initial': 'LO',
      'name': 'Lina Oktaviani',
      'role': 'peminjam',
      'username': 'lina',
      'password': 'lina123',
      'color': Colors.deepOrange
    },
  ];

  // Controller untuk form
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic>? selectedUser;
  String? selectedRole;
  bool isEditing = false;
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(dummyUsers);
    // Set default role
    selectedRole = 'admin';
  }

  void _searchUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredUsers = List.from(dummyUsers);
      });
    } else {
      setState(() {
        filteredUsers = dummyUsers.where((user) {
          final name = user['name'].toString().toLowerCase();
          final username = user['username'].toString().toLowerCase();
          final role = user['role'].toString().toLowerCase();
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              username.contains(searchLower) ||
              role.contains(searchLower);
        }).toList();
      });
    }
  }

  void _selectUser(Map<String, dynamic> user) {
    setState(() {
      selectedUser = user;
      isEditing = true;
      _namaController.text = user['name'];
      _usernameController.text = user['username'];
      _passwordController.text = user['password'];
      selectedRole = user['role'];
    });
  }

  void _saveUser() {
    if (_namaController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua field')),
      );
      return;
    }

    // Validasi username unik (kecuali untuk user yang sedang diedit)
    if (isEditing && selectedUser != null) {
      // Saat edit, cek apakah username berubah dan apakah username baru sudah digunakan
      final currentUsername = selectedUser!['username'];
      final newUsername = _usernameController.text;

      if (newUsername != currentUsername) {
        final usernameExists = dummyUsers.any((user) =>
            user['username'] == newUsername &&
            user['id'] != selectedUser!['id']);

        if (usernameExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username sudah digunakan')),
          );
          return;
        }
      }
    } else {
      // Saat tambah baru, cek apakah username sudah ada
      final usernameExists = dummyUsers
          .any((user) => user['username'] == _usernameController.text);

      if (usernameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username sudah digunakan')),
        );
        return;
      }
    }

    if (isEditing && selectedUser != null) {
      // Update user
      final index =
          dummyUsers.indexWhere((user) => user['id'] == selectedUser!['id']);
      if (index != -1) {
        dummyUsers[index] = {
          'id': selectedUser!['id'],
          'initial': _namaController.text.substring(0, 2).toUpperCase(),
          'name': _namaController.text,
          'role': selectedRole!,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'color': dummyUsers[index]['color'], // Pertahankan warna yang sama
        };

        // Update filtered list
        _searchUsers(_searchController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil diperbarui')),
        );
      }
    } else {
      // Tambah user baru
      final newId = dummyUsers.isNotEmpty ? dummyUsers.last['id'] + 1 : 1;
      final colors = [
        Colors.blue,
        Colors.green,
        Colors.purple,
        Colors.teal,
        Colors.orange,
        Colors.cyan,
        Colors.indigo,
        Colors.amber,
        Colors.lime,
        Colors.deepPurple,
        Colors.pink,
        Colors.brown,
        Colors.grey,
        Colors.deepOrange
      ];
      final color = colors[(newId - 1) % colors.length];

      final newUser = {
        'id': newId,
        'initial': _namaController.text.substring(0, 2).toUpperCase(),
        'name': _namaController.text,
        'role': selectedRole!,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'color': color,
      };

      dummyUsers.add(newUser);

      // Update filtered list
      _searchUsers(_searchController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User baru berhasil ditambahkan')),
      );
    }

    _clearForm();
  }

  void _deleteUser() {
    if (selectedUser == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus user "${selectedUser!['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              dummyUsers
                  .removeWhere((user) => user['id'] == selectedUser!['id']);
              _searchUsers(_searchController.text);
              _clearForm();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User berhasil dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mendapatkan display name role
  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'petugas':
        return 'Petugas Lab';
      case 'peminjam':
        return 'Peminjam';
      default:
        return role;
    }
  }

  bool _showFormOnMobile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Pengelolaan User'),
        backgroundColor: const Color(0xFFF9D59B),
        elevation: 0,
        leading: IconButton(
          icon: Icon(_showFormOnMobile ? Icons.arrow_back : Icons.arrow_back),
          onPressed: () {
            if (_showFormOnMobile) {
              setState(() => _showFormOnMobile = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left: Daftar User
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    border: Border(
                        right: BorderSide(color: Colors.orange.shade200)),
                  ),
                  child: _buildUserList(),
                ),
                // Right: Form detail
                Expanded(
                  child: _buildUserFormArea(true),
                ),
              ],
            );
          } else {
            // Mobile layout: switch between list and form
            return _showFormOnMobile
                ? _buildUserFormArea(false)
                : _buildUserList();
          }
        },
      ),
    );
  }

  Widget _buildUserList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
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
            onChanged: _searchUsers,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              final isSelected = selectedUser?['id'] == user['id'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Material(
                  color:
                      isSelected ? Colors.orange.shade100 : Colors.transparent,
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
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.orange.shade900
                            : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      _getRoleDisplayName(user['role']),
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user['username'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_square, size: 20),
                          color: Colors.orange,
                          onPressed: () {
                            _selectUser(user);
                            if (MediaQuery.of(context).size.width <= 900) {
                              setState(() => _showFormOnMobile = true);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _selectUser(user);
                      if (MediaQuery.of(context).size.width <= 900) {
                        setState(() => _showFormOnMobile = true);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _clearForm() {
    setState(() {
      selectedUser = null;
      isEditing = false;
      _namaController.clear();
      _usernameController.clear();
      _passwordController.clear();
      selectedRole = 'admin';
      if (MediaQuery.of(context).size.width <= 900) {
        _showFormOnMobile = true;
      }
    });
  }

  Widget _buildUserFormArea(bool isWide) {
    return Container(
      color: const Color(0xFFFFF8E1),
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 24), // Reduced horizontal padding
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isWide)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => _showFormOnMobile = false),
                  ),
                const Expanded(
                  child: Text(
                    'Pengelolaan User',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    if (isEditing && selectedUser != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Hapus User',
                        onPressed: _deleteUser,
                      ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.orange),
                      tooltip: 'Tambah User',
                      onPressed: _clearForm,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing
                          ? 'Edit User: ${selectedUser?['name']}'
                          : 'Tambah User Baru',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(_namaController, 'Nama Lengkap',
                        'Masukkan nama lengkap'),
                    const SizedBox(height: 20),
                    _buildTextField(_usernameController, 'Username',
                        'contoh: admin, petugas1, andi'),
                    const SizedBox(height: 20),
                    _buildTextField(
                        _passwordController, 'Password', 'Masukkan password',
                        isPassword: true),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Jabatan / Role',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      value: selectedRole,
                      items: const [
                        DropdownMenuItem(
                          value: 'admin',
                          child: Text('Admin'),
                        ),
                        DropdownMenuItem(
                          value: 'petugas',
                          child: Text('Petugas Lab'),
                        ),
                        DropdownMenuItem(
                          value: 'peminjam',
                          child: Text('Peminjam'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade800,
                          ),
                          onPressed: () {
                            setState(() => _showFormOnMobile = false);
                            _clearForm();
                          },
                          child: const Text('Batal'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                          ),
                          onPressed: _saveUser,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
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

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
