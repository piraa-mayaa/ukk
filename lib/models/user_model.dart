class UserModel {
  final int id;
  final String nama;
  final String username;
  final String role;

  UserModel({
    required this.id,
    required this.nama,
    required this.username,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id_user'] as int,
      nama: map['nama'] as String,
      username: map['username'] as String,
      role: map['role'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_user': id,
      'nama': nama,
      'username': username,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nama: $nama, username: $username, role: $role)';
  }
}
