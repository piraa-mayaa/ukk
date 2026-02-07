import 'user_model.dart';

class LogAktivitasModel {
  final int id;
  final int? idUser;
  final String aktivitas;
  final DateTime waktu;

  // Relation
  final UserModel? user;

  LogAktivitasModel({
    required this.id,
    this.idUser,
    required this.aktivitas,
    required this.waktu,
    this.user,
  });

  factory LogAktivitasModel.fromMap(Map<String, dynamic> map) {
    return LogAktivitasModel(
      id: map['id_log'] as int,
      idUser: map['id_user'] as int?,
      aktivitas: map['aktivitas'] as String,
      waktu: DateTime.parse(map['waktu'] as String),
      user: map['users'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['users']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_log': id,
      'id_user': idUser,
      'aktivitas': aktivitas,
      'waktu': waktu.toIso8601String(),
    };
  }

  String get namaUser {
    if (user != null) return user!.nama;
    if (idUser != null) return 'User #$idUser';
    return 'System';
  }

  @override
  String toString() {
    return 'LogAktivitasModel(id: $id, user: $namaUser, aktivitas: $aktivitas)';
  }
}
