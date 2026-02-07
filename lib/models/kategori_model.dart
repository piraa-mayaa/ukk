class KategoriModel {
  final int id;
  final String nama;
  final String? keterangan;
  int? jumlahAlat; // Field tambahan untuk jumlah alat

  KategoriModel({
    required this.id,
    required this.nama,
    this.keterangan,
    this.jumlahAlat = 0,
  });

  factory KategoriModel.fromMap(Map<String, dynamic> map) {
    return KategoriModel(
      id: map['id_kategori'] as int,
      nama: map['nama_kategori'] as String,
      keterangan: map['keterangan'] as String?,
      jumlahAlat: (map['jumlah_alat'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_kategori': id,
      'nama_kategori': nama,
      'keterangan': keterangan,
    };
  }

  // Untuk form validation
  bool get isValid => nama.trim().isNotEmpty;
  
  String? get errorMessage {
    if (nama.trim().isEmpty) return 'Nama kategori harus diisi';
    return null;
  }

  @override
  String toString() {
    return 'KategoriModel(id: $id, nama: $nama, alat: $jumlahAlat)';
  }
}