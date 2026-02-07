import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/alat_model_api.dart';

class ServiceAlat {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== GET ALL ALAT ====================
  Future<List<AlatModel>> getAlats({int? kategoriId}) async {
    try {
      var query = _supabase.from('alat').select('*, kategori(*)');

      if (kategoriId != null) {
        query = query.eq('id_kategori', kategoriId);
      }

      final data = await query.order('id_alat', ascending: false);

      return (data as List)
          .map((e) => AlatModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getAlats: $e');
      return [];
    }
  }

  // ==================== GET ALAT BY ID ====================
  Future<AlatModel?> getAlatById(int id) async {
    try {
      final data = await _supabase
          .from('alat')
          .select('*, kategori(*)')
          .eq('id_alat', id)
          .single();

      return AlatModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error getAlatById: $e');
      return null;
    }
  }

  // ==================== CREATE ALAT ====================
  Future<AlatModel?> createAlat({
    required String kodeAlat,
    required String namaAlat,
    String? kondisi,
    String? status,
    int? idKategori,
    String? fotoPath,
  }) async {
    try {
      final data = await _supabase
          .from('alat')
          .insert({
            'kode_alat': kodeAlat,
            'nama_alat': namaAlat,
            'kondisi': kondisi ?? 'baik',
            'status': status ?? 'tersedia',
            'id_kategori': idKategori,
            'foto': fotoPath,
          })
          .select('*, kategori(*)')
          .single();

      return AlatModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error createAlat: $e');
      return null;
    }
  }

  // ==================== UPDATE ALAT ====================
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

      await _supabase.from('alat').update(payload).eq('id_alat', id);

      return true;
    } catch (e) {
      debugPrint('Error updateAlat: $e');
      return false;
    }
  }

  // ==================== DELETE ALAT ====================
  Future<bool> deleteAlat(int id) async {
    try {
      await _supabase.from('alat').delete().eq('id_alat', id);
      return true;
    } catch (e) {
      debugPrint('Error deleteAlat: $e');
      return false;
    }
  }

  // ==================== SEARCH & FILTER ====================
  Future<List<AlatModel>> searchAlat(String keyword) async {
    try {
      final data = await _supabase
          .from('alat')
          .select('*, kategori(*)')
          .or('nama_alat.ilike.%$keyword%,kode_alat.ilike.%$keyword%')
          .order('id_alat', ascending: false);

      return (data as List)
          .map((e) => AlatModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error searchAlat: $e');
      return [];
    }
  }

  Future<List<AlatModel>> filterAlatByKategori(int idKategori) async {
    try {
      final data = await _supabase
          .from('alat')
          .select('*, kategori(*)')
          .eq('id_kategori', idKategori)
          .order('id_alat', ascending: false);

      return (data as List)
          .map((e) => AlatModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error filterAlatByKategori: $e');
      return [];
    }
  }
}
