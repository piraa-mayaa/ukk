import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pengembalian_model.dart';
import 'service_peminjaman.dart';

class ServicePengembalian {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ServicePeminjaman _servicePeminjaman = ServicePeminjaman();

  // Denda per hari terlambat (dalam rupiah)
  static const double dendaPerHari = 5000;

  // ==================== CREATE PENGEMBALIAN ====================

  /// Create pengembalian record only (without processing)
  Future<int?> createPengembalian({
    required int idPeminjaman,
    required DateTime tanggalDikembalikan,
    required String kondisiKembali,
    double? denda,
  }) async {
    try {
      final response = await _supabase
          .from('pengembalian')
          .insert({
            'id_peminjaman': idPeminjaman,
            'tanggal_dikembalikan':
                tanggalDikembalikan.toIso8601String().split('T')[0],
            'kondisi_kembali': kondisiKembali,
            'denda': denda ?? 0,
          })
          .select('id_pengembalian')
          .single();

      final idPengembalian = response['id_pengembalian'] as int;
      debugPrint('✅ Pengembalian created: $idPengembalian');
      return idPengembalian;
    } catch (e) {
      debugPrint('Error createPengembalian: $e');
      return null;
    }
  }

  /// Process complete return workflow
  /// - Create pengembalian
  /// - Update peminjaman status = 'selesai'
  /// - Restore all alat status = 'tersedia'
  /// - Update alat kondisi if 'rusak'
  Future<bool> processKembalian({
    required int idPeminjaman,
    required DateTime tanggalDikembalikan,
    required String kondisiKembali,
  }) async {
    try {
      // 1. Get peminjaman data
      final peminjaman =
          await _servicePeminjaman.getPeminjamanById(idPeminjaman);
      if (peminjaman == null) {
        debugPrint('Error: Peminjaman not found');
        return false;
      }

      // 2. Calculate denda if late
      final denda = await calculateDenda(idPeminjaman, tanggalDikembalikan);

      // 3. Create pengembalian record
      final idPengembalian = await createPengembalian(
        idPeminjaman: idPeminjaman,
        tanggalDikembalikan: tanggalDikembalikan,
        kondisiKembali: kondisiKembali,
        denda: denda,
      );

      if (idPengembalian == null) {
        debugPrint('Error: Failed to create pengembalian');
        return false;
      }

      // 4. Update peminjaman status to 'selesai'
      await _servicePeminjaman.updateStatusPeminjaman(idPeminjaman, 'selesai');

      // 5. Restore all alat status and update kondisi if damaged
      if (peminjaman.details != null) {
        for (var detail in peminjaman.details!) {
          // Restore status to 'tersedia'
          await _servicePeminjaman.updateAlatStatus(detail.idAlat, 'tersedia');

          // If damaged, update kondisi alat
          if (kondisiKembali == 'rusak') {
            await _updateKondisiAlat(detail.idAlat, 'rusak');
          }
        }
      }

      debugPrint(
          '✅ Kembalian processed successfully for peminjaman $idPeminjaman');
      return true;
    } catch (e) {
      debugPrint('Error processKembalian: $e');
      return false;
    }
  }

  // ==================== READ PENGEMBALIAN ====================

  /// Get all pengembalian
  Future<List<PengembalianModel>> getAllPengembalian() async {
    try {
      final data = await _supabase
          .from('pengembalian')
          .select('*, peminjaman(*, users(*), detail_peminjaman(*, alat(*)))')
          .order('id_pengembalian', ascending: false);

      return (data as List)
          .map((e) => PengembalianModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getAllPengembalian: $e');
      return [];
    }
  }

  /// Get pengembalian by peminjaman ID
  Future<PengembalianModel?> getPengembalianByPeminjaman(
      int idPeminjaman) async {
    try {
      final data = await _supabase
          .from('pengembalian')
          .select('*, peminjaman(*, users(*), detail_peminjaman(*, alat(*)))')
          .eq('id_peminjaman', idPeminjaman)
          .maybeSingle();

      if (data == null) return null;

      return PengembalianModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error getPengembalianByPeminjaman: $e');
      return null;
    }
  }

  /// Get pengembalian by ID
  Future<PengembalianModel?> getPengembalianById(int id) async {
    try {
      final data = await _supabase
          .from('pengembalian')
          .select('*, peminjaman(*, users(*), detail_peminjaman(*, alat(*)))')
          .eq('id_pengembalian', id)
          .single();

      return PengembalianModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error getPengembalianById: $e');
      return null;
    }
  }

  // ==================== BUSINESS LOGIC ====================

  /// Calculate denda based on late days
  /// Formula: (tanggalDikembalikan - tanggalKembali) * DENDA_PER_HARI
  Future<double> calculateDenda(
      int idPeminjaman, DateTime tanggalDikembalikan) async {
    try {
      final peminjaman =
          await _servicePeminjaman.getPeminjamanById(idPeminjaman);
      if (peminjaman == null) return 0;

      final tanggalKembali = peminjaman.tanggalKembali;

      // If returned on time or early, no denda
      if (tanggalDikembalikan.isBefore(tanggalKembali) ||
          tanggalDikembalikan.isAtSameMomentAs(tanggalKembali)) {
        return 0;
      }

      // Calculate late days
      final lateDays = tanggalDikembalikan.difference(tanggalKembali).inDays;

      // Calculate denda
      final denda = lateDays * dendaPerHari;

      debugPrint('📅 Late days: $lateDays, Denda: Rp $denda');
      return denda;
    } catch (e) {
      debugPrint('Error calculateDenda: $e');
      return 0;
    }
  }

  /// Check if peminjaman can be returned
  /// (status must be 'disetujui' and not already returned)
  Future<bool> canReturn(int idPeminjaman) async {
    try {
      // Check peminjaman status
      final peminjaman =
          await _servicePeminjaman.getPeminjamanById(idPeminjaman);
      if (peminjaman == null) return false;
      if (peminjaman.status != 'disetujui') return false;

      // Check if already returned
      final pengembalian = await getPengembalianByPeminjaman(idPeminjaman);
      if (pengembalian != null) return false;

      return true;
    } catch (e) {
      debugPrint('Error canReturn: $e');
      return false;
    }
  }

  /// Update kondisi alat
  Future<bool> _updateKondisiAlat(int idAlat, String kondisi) async {
    try {
      await _supabase
          .from('alat')
          .update({'kondisi': kondisi}).eq('id_alat', idAlat);

      debugPrint('✅ Alat $idAlat kondisi updated to: $kondisi');
      return true;
    } catch (e) {
      debugPrint('Error _updateKondisiAlat: $e');
      return false;
    }
  }

  /// Count total pengembalian
  Future<int> countPengembalian() async {
    try {
      final data = await _supabase.from('pengembalian').select();
      return (data as List).length;
    } catch (e) {
      debugPrint('Error countPengembalian: $e');
      return 0;
    }
  }

  /// Get total denda
  Future<double> getTotalDenda() async {
    try {
      final data = await _supabase.from('pengembalian').select('denda');

      double total = 0;
      for (var item in data) {
        total += (item['denda'] ?? 0).toDouble();
      }

      return total;
    } catch (e) {
      debugPrint('Error getTotalDenda: $e');
      return 0;
    }
  }
}
