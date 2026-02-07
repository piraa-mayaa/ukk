import 'user_model.dart';
import 'detail_peminjaman_model.dart';

class PeminjamanModel {
  final int id;
  final int idUser;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;
  final String status; // 'menunggu', 'disetujui', 'ditolak', 'selesai'

  // Relations
  final UserModel? user;
  final List<DetailPeminjamanModel>? details;

  PeminjamanModel({
    required this.id,
    required this.idUser,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.status,
    this.user,
    this.details,
  });

  factory PeminjamanModel.fromMap(Map<String, dynamic> map) {
    return PeminjamanModel(
      id: map['id_peminjaman'] as int,
      idUser: map['id_user'] as int,
      tanggalPinjam: DateTime.parse(map['tanggal_pinjam'] as String),
      tanggalKembali: DateTime.parse(map['tanggal_kembali'] as String),
      status: map['status'] as String,
      user: map['users'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['users']))
          : null,
      details: map['detail_peminjaman'] != null
          ? (map['detail_peminjaman'] as List)
              .map((e) =>
                  DetailPeminjamanModel.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_peminjaman': id,
      'id_user': idUser,
      'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T')[0],
      'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
      'status': status,
    };
  }

  // Helper getters
  String get statusLabel {
    switch (status) {
      case 'menunggu':
        return 'Menunggu Persetujuan';
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      case 'selesai':
        return 'Selesai';
      default:
        return status;
    }
  }

  bool get isMenunggu => status == 'menunggu';
  bool get isDisetujui => status == 'disetujui';
  bool get isDitolak => status == 'ditolak';
  bool get isSelesai => status == 'selesai';

  // Nama peminjam (from user relation)
  String? get namaPeminjam => user?.nama;

  @override
  String toString() {
    return 'PeminjamanModel(id: $id, idUser: $idUser, status: $status, tanggalPinjam: $tanggalPinjam)';
  }
}
