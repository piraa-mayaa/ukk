import 'peminjaman_model.dart';

class PengembalianModel {
  final int id;
  final int idPeminjaman;
  final DateTime tanggalDikembalikan;
  final String? kondisiKembali; // 'baik' or 'rusak'
  final double denda;

  // Relation
  final PeminjamanModel? peminjaman;

  PengembalianModel({
    required this.id,
    required this.idPeminjaman,
    required this.tanggalDikembalikan,
    this.kondisiKembali,
    this.denda = 0,
    this.peminjaman,
  });

  factory PengembalianModel.fromMap(Map<String, dynamic> map) {
    return PengembalianModel(
      id: map['id_pengembalian'] as int,
      idPeminjaman: map['id_peminjaman'] as int,
      tanggalDikembalikan:
          DateTime.parse(map['tanggal_dikembalikan'] as String),
      kondisiKembali: map['kondisi_kembali'] as String?,
      denda: (map['denda'] ?? 0).toDouble(),
      peminjaman: map['peminjaman'] != null
          ? PeminjamanModel.fromMap(
              Map<String, dynamic>.from(map['peminjaman']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_pengembalian': id,
      'id_peminjaman': idPeminjaman,
      'tanggal_dikembalikan':
          tanggalDikembalikan.toIso8601String().split('T')[0],
      'kondisi_kembali': kondisiKembali,
      'denda': denda,
    };
  }

  // For creating new pengembalian (without id)
  Map<String, dynamic> toInsertMap() {
    return {
      'id_peminjaman': idPeminjaman,
      'tanggal_dikembalikan':
          tanggalDikembalikan.toIso8601String().split('T')[0],
      'kondisi_kembali': kondisiKembali,
      'denda': denda,
    };
  }

  // Helper getters
  bool get hasDenda => denda > 0;
  bool get isKondisiBaik => kondisiKembali == 'baik';
  bool get isKondisiRusak => kondisiKembali == 'rusak';

  String get kondisiLabel {
    if (kondisiKembali == null) return '-';
    return kondisiKembali == 'baik' ? 'Baik' : 'Rusak';
  }

  @override
  String toString() {
    return 'PengembalianModel(id: $id, idPeminjaman: $idPeminjaman, tanggalDikembalikan: $tanggalDikembalikan, denda: $denda)';
  }
}
