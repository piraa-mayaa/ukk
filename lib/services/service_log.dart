import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/log_aktivitas_model.dart';

class ServiceLog {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all logs from database
  Future<List<LogAktivitasModel>> getAllLogs() async {
    try {
      final data = await _supabase
          .from('log_aktivitas')
          .select('*, users(*)')
          .order('waktu', ascending: false);

      return (data as List)
          .map((e) => LogAktivitasModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getAllLogs: $e');
      return [];
    }
  }

  /// Add new activity log
  Future<bool> addLog(int? idUser, String aktivitas) async {
    try {
      await _supabase.from('log_aktivitas').insert({
        'id_user': idUser,
        'aktivitas': aktivitas,
      });
      return true;
    } catch (e) {
      debugPrint('Error addLog: $e');
      return false;
    }
  }
}
