import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori_model.dart';

class ServiceKategori {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== GET ALL KATEGORI ====================
  Future<List<KategoriModel>> getAllKategori() async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('*')
          .order('id_kategori', ascending: true);

      return (response as List)
          .map((json) => KategoriModel.fromMap(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      debugPrint('Error getAllKategori: $e');
      return [];
    }
  }

  // ==================== GET KATEGORI BY ID ====================
  Future<KategoriModel?> getKategoriById(int id) async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('*')
          .eq('id_kategori', id)
          .single();

      return KategoriModel.fromMap(Map<String, dynamic>.from(response));
    } catch (e) {
      debugPrint('Error getKategoriById: $e');
      return null;
    }
  }

  // ==================== SEARCH KATEGORI ====================
  Future<List<KategoriModel>> searchKategori(String keyword) async {
    try {
      final response = await _supabase
          .from('kategori')
          .select('*')
          .ilike('nama_kategori', '%$keyword%')
          .order('id_kategori', ascending: true);

      return (response as List)
          .map((json) => KategoriModel.fromMap(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      debugPrint('Error searchKategori: $e');
      return [];
    }
  }

  // ==================== CREATE KATEGORI ====================
  Future<KategoriModel?> createKategori({
    required String nama,
    String? keterangan,
  }) async {
    try {
      final response = await _supabase
          .from('kategori')
          .insert({
            'nama_kategori': nama,
            'keterangan': keterangan,
          })
          .select()
          .single();

      return KategoriModel.fromMap(Map<String, dynamic>.from(response));
    } catch (e) {
      debugPrint('Error createKategori: $e');
      return null;
    }
  }

  // ==================== UPDATE KATEGORI ====================
  Future<bool> updateKategori({
    required int id,
    String? nama,
    String? keterangan,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      
      if (nama != null && nama.isNotEmpty) {
        updates['nama_kategori'] = nama;
      }
      
      if (keterangan != null) {
        updates['keterangan'] = keterangan;
      }

      if (updates.isEmpty) {
        return false;
      }

      await _supabase
          .from('kategori')
          .update(updates)
          .eq('id_kategori', id);

      return true;
    } catch (e) {
      debugPrint('Error updateKategori: $e');
      return false;
    }
  }

  // ==================== DELETE KATEGORI ====================
  Future<bool> deleteKategori(int id) async {
    try {
      // Cek apakah kategori digunakan di tabel alat
      final alatResponse = await _supabase
          .from('alat')
          .select('id_alat')
          .eq('id_kategori', id)
          .limit(1);

      if ((alatResponse as List).isNotEmpty) {
        return false;
      }

      await _supabase
          .from('kategori')
          .delete()
          .eq('id_kategori', id);

      return true;
    } catch (e) {
      debugPrint('Error deleteKategori: $e');
      return false;
    }
  }

  // ==================== COUNT ALAT BY KATEGORI ====================
  Future<int> countAlatByKategori(int idKategori) async {
    try {
      final response = await _supabase
          .from('alat')
          .select()
          .eq('id_kategori', idKategori);

      return (response as List).length;
    } catch (e) {
      debugPrint('Error countAlatByKategori: $e');
      return 0;
    }
  }

  // ==================== CHECK DUPLICATE NAMA ====================
  Future<bool> isNamaKategoriExists(String nama, {int? excludeId}) async {
    try {
      var query = _supabase
          .from('kategori')
          .select('id_kategori')
          .eq('nama_kategori', nama);

      if (excludeId != null) {
        query = query.neq('id_kategori', excludeId);
      }

      final response = await query.limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      debugPrint('Error isNamaKategoriExists: $e');
      return false;
    }
  }

  // ==================== GET KATEGORI WITH ALAT COUNT ====================
  Future<List<Map<String, dynamic>>> getKategoriWithAlatCount() async {
    try {
      final kategoriList = await getAllKategori();
      final result = <Map<String, dynamic>>[];

      for (var kategori in kategoriList) {
        final alatCount = await countAlatByKategori(kategori.id);
        result.add({
          'kategori': kategori,
          'alat_count': alatCount,
        });
      }

      return result;
    } catch (e) {
      debugPrint('Error getKategoriWithAlatCount: $e');
      return [];
    }
  }

  // ==================== GET KATEGORI STATS ====================
  Future<Map<String, dynamic>> getKategoriStats() async {
    try {
      final totalResponse = await _supabase
          .from('kategori')
          .select();

      final kategoriWithAlat = await getKategoriWithAlatCount();
      
      // Urutkan berdasarkan jumlah alat terbanyak
      kategoriWithAlat.sort((a, b) => (b['alat_count'] as int).compareTo(a['alat_count'] as int));

      return {
        'total': (totalResponse as List).length,
        'top_kategori': kategoriWithAlat.take(5).toList(),
      };
    } catch (e) {
      debugPrint('Error getKategoriStats: $e');
      return {'total': 0, 'top_kategori': []};
    }
  }
}