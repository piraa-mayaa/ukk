class AlatModel {
  final int id;
  final String kode;
  final String nama;
  final String? kondisi;
  final String? status;
  final int? idKategori;
  final String? fotoUrl;

  AlatModel({
    required this.id,
    required this.kode,
    required this.nama,
    this.kondisi,
    this.status,
    this.idKategori,
    this.fotoUrl,
  });

  factory AlatModel.fromMap(Map<String, dynamic> m) => AlatModel(
        id: m['id_alat'] as int,
        kode: m['kode_alat'] as String,
        nama: m['nama_alat'] as String,
        kondisi: m['kondisi'] as String?,
        status: m['status'] as String?,
        idKategori: m['id_kategori'] as int?,
        fotoUrl: m['foto'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id_alat': id,
        'kode_alat': kode,
        'nama_alat': nama,
        'kondisi': kondisi,
        'status': status,
        'id_kategori': idKategori,
        'foto': fotoUrl,
      };
}
