import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peminjaman_model.dart';
import '../models/detail_peminjaman_model.dart';
import 'service_log.dart';

class ServicePeminjaman {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ServiceLog _serviceLog = ServiceLog();

  // ==================== CREATE PEMINJAMAN ====================

  /// Create peminjaman with detail (multiple alat)
  /// Returns id_peminjaman if success, null if failed
  Future<int?> createPeminjaman({
    required int idUser,
    required DateTime tanggalPinjam,
    required DateTime tanggalKembali,
    required List<int> idAlatList,
  }) async {
    try {
      // 1. Validate dates
      if (tanggalKembali.isBefore(tanggalPinjam)) {
        debugPrint('Error: Tanggal kembali harus setelah tanggal pinjam');
        return null;
      }

      // 2. Check all alat are available
      for (int idAlat in idAlatList) {
        final isAvailable = await checkAlatAvailable(idAlat);
        if (!isAvailable) {
          debugPrint('Error: Alat $idAlat tidak tersedia');
          return null;
        }
      }

      // 3. Create peminjaman record
      final peminjamanData = await _supabase
          .from('peminjaman')
          .insert({
            'id_user': idUser,
            'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T')[0],
            'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
            'status': 'menunggu',
          })
          .select('id_peminjaman')
          .single();

      final idPeminjaman = peminjamanData['id_peminjaman'] as int;

      // 4. Create detail_peminjaman for each alat
      final details = idAlatList
          .map((idAlat) => {
                'id_peminjaman': idPeminjaman,
                'id_alat': idAlat,
              })
          .toList();

      await _supabase.from('detail_peminjaman').insert(details);

      debugPrint('✅ Peminjaman created: $idPeminjaman');

      // 5. Add to Log
      await _serviceLog.addLog(
          idUser, 'Mengajukan peminjaman alat (ID: $idPeminjaman)');

      return idPeminjaman;
    } catch (e) {
      debugPrint('Error createPeminjaman: $e');
      return null;
    }
  }

  // ==================== READ PEMINJAMAN ====================

  /// Get all peminjaman (for admin/petugas)
  Future<List<PeminjamanModel>> getAllPeminjaman() async {
    try {
      final data = await _supabase
          .from('peminjaman')
          .select('*, users(*), detail_peminjaman(*, alat(*))')
          .order('id_peminjaman', ascending: false);

      return (data as List)
          .map((e) => PeminjamanModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getAllPeminjaman: $e');
      return [];
    }
  }

  /// Get peminjaman by user (for peminjam role)
  Future<List<PeminjamanModel>> getPeminjamanByUser(int idUser) async {
    try {
      final data = await _supabase
          .from('peminjaman')
          .select('*, users(*), detail_peminjaman(*, alat(*))')
          .eq('id_user', idUser)
          .order('id_peminjaman', ascending: false);

      return (data as List)
          .map((e) => PeminjamanModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getPeminjamanByUser: $e');
      return [];
    }
  }

  /// Get peminjaman by status (for filtering)
  Future<List<PeminjamanModel>> getPeminjamanByStatus(String status) async {
    try {
      final data = await _supabase
          .from('peminjaman')
          .select('*, users(*), detail_peminjaman(*, alat(*))')
          .eq('status', status)
          .order('id_peminjaman', ascending: false);

      return (data as List)
          .map((e) => PeminjamanModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getPeminjamanByStatus: $e');
      return [];
    }
  }

  /// Get single peminjaman by ID
  Future<PeminjamanModel?> getPeminjamanById(int id) async {
    try {
      final data = await _supabase
          .from('peminjaman')
          .select('*, users(*), detail_peminjaman(*, alat(*))')
          .eq('id_peminjaman', id)
          .single();

      return PeminjamanModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error getPeminjamanById: $e');
      return null;
    }
  }

  // ==================== UPDATE PEMINJAMAN ====================

  /// Update status peminjaman
  Future<bool> updateStatusPeminjaman(int id, String status) async {
    try {
      await _supabase
          .from('peminjaman')
          .update({'status': status}).eq('id_peminjaman', id);

      debugPrint('✅ Peminjaman $id status updated to: $status');
      return true;
    } catch (e) {
      debugPrint('Error updateStatusPeminjaman: $e');
      return false;
    }
  }

  /// Approve peminjaman (petugas action)
  /// - Update status to 'disetujui'
  /// - Update all alat status to 'dipinjam'
  Future<bool> approvePeminjaman(int id) async {
    try {
      // 1. Get peminjaman with details
      final peminjaman = await getPeminjamanById(id);
      if (peminjaman == null || peminjaman.details == null) {
        debugPrint('Error: Peminjaman not found');
        return false;
      }

      // 2. Check all alat still available (re-check)
      for (var detail in peminjaman.details!) {
        final isAvailable = await checkAlatAvailable(detail.idAlat);
        if (!isAvailable) {
          debugPrint('Error: Alat ${detail.idAlat} tidak lagi tersedia');
          return false;
        }
      }

      // 3. Update peminjaman status
      await updateStatusPeminjaman(id, 'disetujui');

      // 4. Update all alat status to 'dipinjam'
      for (var detail in peminjaman.details!) {
        await updateAlatStatus(detail.idAlat, 'dipinjam');
      }

      debugPrint('✅ Peminjaman $id approved');

      // 5. Add to Log
      await _serviceLog.addLog(null, 'Menyetujui peminjaman alat (ID: $id)');

      return true;
    } catch (e) {
      debugPrint('Error approvePeminjaman: $e');
      return false;
    }
  }

  /// Reject peminjaman (petugas action)
  Future<bool> rejectPeminjaman(int id) async {
    try {
      await updateStatusPeminjaman(id, 'ditolak');
      debugPrint('✅ Peminjaman $id rejected');

      // Add to Log
      await _serviceLog.addLog(null, 'Menolak peminjaman alat (ID: $id)');

      return true;
    } catch (e) {
      debugPrint('Error rejectPeminjaman: $e');
      return false;
    }
  }

  // ==================== BUSINESS LOGIC ====================

  /// Check if alat is available (status = 'tersedia')
  Future<bool> checkAlatAvailable(int idAlat) async {
    try {
      final data = await _supabase
          .from('alat')
          .select('status')
          .eq('id_alat', idAlat)
          .single();

      return data['status'] == 'tersedia';
    } catch (e) {
      debugPrint('Error checkAlatAvailable: $e');
      return false;
    }
  }

  /// Update alat status (tersedia/dipinjam)
  Future<bool> updateAlatStatus(int idAlat, String status) async {
    try {
      await _supabase
          .from('alat')
          .update({'status': status}).eq('id_alat', idAlat);

      debugPrint('✅ Alat $idAlat status updated to: $status');
      return true;
    } catch (e) {
      debugPrint('Error updateAlatStatus: $e');
      return false;
    }
  }

  /// Get detail peminjaman by peminjaman ID
  Future<List<DetailPeminjamanModel>> getDetailByPeminjaman(
      int idPeminjaman) async {
    try {
      final data = await _supabase
          .from('detail_peminjaman')
          .select('*, alat(*)')
          .eq('id_peminjaman', idPeminjaman);

      return (data as List)
          .map((e) =>
              DetailPeminjamanModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getDetailByPeminjaman: $e');
      return [];
    }
  }

  /// Count total peminjaman
  Future<int> countPeminjaman() async {
    try {
      final data = await _supabase.from('peminjaman').select();
      return (data as List).length;
    } catch (e) {
      debugPrint('Error countPeminjaman: $e');
      return 0;
    }
  }

  /// Count peminjaman by status
  Future<int> countPeminjamanByStatus(String status) async {
    try {
      final data =
          await _supabase.from('peminjaman').select().eq('status', status);
      return (data as List).length;
    } catch (e) {
      debugPrint('Error countPeminjamanByStatus: $e');
      return 0;
    }
  }
}
