import 'alat_model_api.dart';

class DetailPeminjamanModel {
  final int id;
  final int idPeminjaman;
  final int idAlat;

  // Relation
  final AlatModel? alat;

  DetailPeminjamanModel({
    required this.id,
    required this.idPeminjaman,
    required this.idAlat,
    this.alat,
  });

  factory DetailPeminjamanModel.fromMap(Map<String, dynamic> map) {
    return DetailPeminjamanModel(
      id: map['id_detail'] as int,
      idPeminjaman: map['id_peminjaman'] as int,
      idAlat: map['id_alat'] as int,
      alat: map['alat'] != null
          ? AlatModel.fromMap(Map<String, dynamic>.from(map['alat']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_detail': id,
      'id_peminjaman': idPeminjaman,
      'id_alat': idAlat,
    };
  }

  // For creating new detail (without id)
  Map<String, dynamic> toInsertMap() {
    return {
      'id_peminjaman': idPeminjaman,
      'id_alat': idAlat,
    };
  }

  // Helper getters
  String? get namaAlat => alat?.nama;
  String? get kodeAlat => alat?.kode;

  @override
  String toString() {
    return 'DetailPeminjamanModel(id: $id, idPeminjaman: $idPeminjaman, idAlat: $idAlat, namaAlat: $namaAlat)';
  }
}
