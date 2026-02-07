import 'kategori_model.dart';

class AlatModel {
  final int id;
  final String kode;
  final String nama;
  final String? kondisi;
  final String? status;
  final int? idKategori;
  final String? foto;
  final KategoriModel? kategori;

  AlatModel({
    required this.id,
    required this.kode,
    required this.nama,
    this.kondisi,
    this.status,
    this.idKategori,
    this.foto,
    this.kategori,
  });

  factory AlatModel.fromMap(Map<String, dynamic> map) {
    return AlatModel(
      id: map['id_alat'] as int,
      kode: map['kode_alat'] as String,
      nama: map['nama_alat'] as String,
      kondisi: map['kondisi'] as String?,
      status: map['status'] as String?,
      idKategori: map['id_kategori'] as int?,
      foto: map['foto'] as String?,
      kategori: map['kategori'] != null
          ? KategoriModel.fromMap(Map<String, dynamic>.from(map['kategori']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_alat': id,
      'kode_alat': kode,
      'nama_alat': nama,
      'kondisi': kondisi,
      'status': status,
      'id_kategori': idKategori,
      'foto': foto,
    };
  }

  // Getter untuk nama kategori (untuk pencarian)
  String? get kategoriNama => kategori?.nama;

  @override
  String toString() {
    return 'AlatModel(id: $id, kode: $kode, nama: $nama, kategori: ${kategori?.nama})';
  }
}