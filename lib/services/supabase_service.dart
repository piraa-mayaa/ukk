import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/kategori_model.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // ==================== LOGIN ====================

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
        id: data['id_user'] as int,
        nama: data['nama'] as String,
        username: data['username'] as String,
        role: data['role'] as String,
      );
    } catch (e) {
      debugPrint('loginWithUsersTable error: $e');
      return null;
    }
  }

  // ==================== KATEGORI ====================

  Future<List<KategoriModel>> getKategoris() async {
    try {
      final data = await client.from('kategori').select().order('id_kategori');

      return (data as List)
          .map((e) => KategoriModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('getKategoris error: $e');
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
      debugPrint('createKategori error: $e');
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
      debugPrint('updateKategori error: $e');
      return false;
    }
  }

  Future<bool> deleteKategori(int id) async {
    try {
      await client.from('kategori').delete().eq('id_kategori', id);
      return true;
    } catch (e) {
      debugPrint('deleteKategori error: $e');
      return false;
    }
  }

  // ==================== ALAT ====================
  // (Tool management logic moved to ServiceAlat)

  // ==================== SEARCH & FILTER ====================

  // ==================== FILE UPLOAD ====================

  Future<String?> uploadFileToBucket(
    String bucket,
    Uint8List bytes,
    String path, {
    String? contentType,
  }) async {
    try {
      await client.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: contentType),
          );

      final publicUrl = client.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      debugPrint('uploadFile error: $e');
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
      debugPrint('deleteFile error: $e');
      return false;
    }
  }
}
