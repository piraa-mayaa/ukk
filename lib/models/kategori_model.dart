class KategoriModel {
  final int id;
  final String nama;
  final String? keterangan;

  KategoriModel({required this.id, required this.nama, this.keterangan});

  factory KategoriModel.fromMap(Map<String, dynamic> m) => KategoriModel(
        id: m['id_kategori'] as int,
        nama: m['nama_kategori'] as String,
        keterangan: m['keterangan'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id_kategori': id,
        'nama_kategori': nama,
        'keterangan': keterangan,
      };
}
