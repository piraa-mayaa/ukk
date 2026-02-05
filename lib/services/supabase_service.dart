import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

import '../models/kategori_model.dart';
import '../models/alat_model_api.dart';
import '../models/user_model.dart';

class SupabaseService {
  final SupabaseClient client = SupabaseConfig.client;

  // ================= KATEGORI =================

  Future<List<KategoriModel>> getKategoris() async {
    try {
      final data = await client.from('kategori').select().order('id_kategori');
      return (data as List)
          .map((e) => KategoriModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      print('getKategoris error: $e');
      return [];
    }
  }

  Future<KategoriModel?> createKategori(
    String nama, {
    String? keterangan,
  }) async {
    try {
      final data = await client
          .from('kategori')
          .insert({
            'nama_kategori': nama,
            'keterangan': keterangan,
          })
          .select()
          .single();

      return KategoriModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      print('createKategori error: $e');
      return null;
    }
  }

  Future<bool> updateKategori(
    int id, {
    String? nama,
    String? keterangan,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (nama != null) updates['nama_kategori'] = nama;
      if (keterangan != null) updates['keterangan'] = keterangan;

      await client.from('kategori').update(updates).eq('id_kategori', id);

      return true;
    } catch (e) {
      print('updateKategori error: $e');
      return false;
    }
  }

  Future<bool> deleteKategori(int id) async {
    try {
      await client.from('kategori').delete().eq('id_kategori', id);

      return true;
    } catch (e) {
      print('deleteKategori error: $e');
      return false;
    }
  }

  // ================= ALAT =================

  Future<List<AlatModel>> getAlats({int? kategoriId}) async {
    try {
      var query = client.from('alat').select('*, kategori(*)');

      if (kategoriId != null) {
        query = query.eq('id_kategori', kategoriId);
      }

      final data = await query.order('id_alat');
      return (data as List)
          .map((e) => AlatModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      print('getAlats error: $e');
      return [];
    }
  }

  Future<AlatModel?> createAlat({
    required String kodeAlat,
    required String namaAlat,
    String? kondisi,
    String? status,
    int? idKategori,
    String? fotoPath,
  }) async {
    try {
      final data = await client
          .from('alat')
          .insert({
            'kode_alat': kodeAlat,
            'nama_alat': namaAlat,
            'kondisi': kondisi,
            'status': status,
            'id_kategori': idKategori,
            'foto': fotoPath,
          })
          .select()
          .single();

      return AlatModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      print('createAlat error: $e');
      return null;
    }
  }

  Future<bool> updateAlat(
    int id, {
    String? kodeAlat,
    String? namaAlat,
    String? kondisi,
    String? status,
    int? idKategori,
    String? fotoPath,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (kodeAlat != null) payload['kode_alat'] = kodeAlat;
      if (namaAlat != null) payload['nama_alat'] = namaAlat;
      if (kondisi != null) payload['kondisi'] = kondisi;
      if (status != null) payload['status'] = status;
      if (idKategori != null) payload['id_kategori'] = idKategori;
      if (fotoPath != null) payload['foto'] = fotoPath;

      await client.from('alat').update(payload).eq('id_alat', id);

      return true;
    } catch (e) {
      print('updateAlat error: $e');
      return false;
    }
  }

  Future<bool> deleteAlat(int id) async {
    try {
      await client.from('alat').delete().eq('id_alat', id);

      return true;
    } catch (e) {
      print('deleteAlat error: $e');
      return false;
    }
  }
  
  Future<UserModel?> loginWithUsersTable(
      String username, String password) async {
    try {
      final data = await client
          .from('users')
          .select()
          .eq('username', username)
          .eq('password', password)
          .maybeSingle();

      if (data == null) return null;
      return UserModel(
          nama: data['nama'] as String, role: data['role'] as String);
    } catch (e) {
      print('loginWithUsersTable error: $e');
      return null;
    }
  }

  Future<String?> uploadFileToBucket(
    String bucket,
    Uint8List bytes,
    String path, {
    String? contentType,
  }) async {
    try {
      final up = await client.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: contentType),
          );

      final pub = client.storage.from(bucket).getPublicUrl(path);
      if (pub is String) return pub;
      try {
        final dyn = pub as dynamic;
        if (dyn.data != null) return dyn.data as String;
        if (dyn.publicURL != null) return dyn.publicURL as String;
        if (dyn.publicUrl != null) return dyn.publicUrl as String;
      } catch (_) {}
      return null;
    } catch (e) {
      print('uploadFile error: $e');
      return null;
    }
  }

  Future<bool> deleteFileFromBucket(
    String bucket,
    String path,
  ) async {
    try {
      await client.storage.from(bucket).remove([path]);
      return true;
    } catch (e) {
      print('deleteFile error: $e');
      return false;
    }
  }
}
