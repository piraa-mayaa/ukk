import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class ServiceUsers {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== CREATE USER ====================

  Future<int?> createUser({
    required String nama,
    required String username,
    required String password,
    required String role, // 'admin', 'petugas', 'peminjam'
  }) async {
    try {
      // Check if username already exists
      final exists = await isUsernameExists(username);
      if (exists) {
        debugPrint('Error: Username already exists');
        return null;
      }

      // Validate password length
      if (password.length < 6) {
        debugPrint('Error: Password must be at least 6 characters');
        return null;
      }

      // Validate role
      if (!['admin', 'petugas', 'peminjam'].contains(role.toLowerCase())) {
        debugPrint('Error: Invalid role');
        return null;
      }

      final response = await _supabase
          .from('users')
          .insert({
            'nama': nama,
            'username': username,
            'password': password, // TODO: Hash password for production
            'role': role.toLowerCase(),
          })
          .select('id_user')
          .single();

      final idUser = response['id_user'] as int;
      debugPrint('✅ User created: $idUser');
      return idUser;
    } catch (e) {
      debugPrint('Error createUser: $e');
      return null;
    }
  }

  // ==================== READ USERS ====================

  /// Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .order('id_user', ascending: false);

      return (data as List)
          .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getAllUsers: $e');
      return [];
    }
  }

  /// Get users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('role', role.toLowerCase())
          .order('id_user', ascending: false);

      return (data as List)
          .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error getUsersByRole: $e');
      return [];
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(int id) async {
    try {
      final data =
          await _supabase.from('users').select().eq('id_user', id).single();

      return UserModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error getUserById: $e');
      return null;
    }
  }

  /// Search users by name or username
  Future<List<UserModel>> searchUsers(String keyword) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .or('nama.ilike.%$keyword%,username.ilike.%$keyword%')
          .order('id_user', ascending: false);

      return (data as List)
          .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('Error searchUsers: $e');
      return [];
    }
  }

  // ==================== UPDATE USER ====================

  Future<bool> updateUser({
    required int id,
    String? nama,
    String? username,
    String? password,
    String? role,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (nama != null && nama.isNotEmpty) {
        updates['nama'] = nama;
      }

      if (username != null && username.isNotEmpty) {
        // Check if new username already exists (exclude current user)
        final exists = await isUsernameExists(username, excludeId: id);
        if (exists) {
          debugPrint('Error: Username already exists');
          return false;
        }
        updates['username'] = username;
      }

      if (password != null && password.isNotEmpty) {
        if (password.length < 6) {
          debugPrint('Error: Password must be at least 6 characters');
          return false;
        }
        updates['password'] = password; // TODO: Hash password
      }

      if (role != null && role.isNotEmpty) {
        if (!['admin', 'petugas', 'peminjam'].contains(role.toLowerCase())) {
          debugPrint('Error: Invalid role');
          return false;
        }
        updates['role'] = role.toLowerCase();
      }

      if (updates.isEmpty) {
        return false;
      }

      await _supabase.from('users').update(updates).eq('id_user', id);

      debugPrint('✅ User $id updated');
      return true;
    } catch (e) {
      debugPrint('Error updateUser: $e');
      return false;
    }
  }

  // ==================== DELETE USER ====================

  Future<bool> deleteUser(int id) async {
    try {
      // Check if user has active peminjaman
      final canDelete = await canDeleteUser(id);
      if (!canDelete) {
        debugPrint('Error: Cannot delete user with active/pending peminjaman');
        return false;
      }

      await _supabase.from('users').delete().eq('id_user', id);

      debugPrint('✅ User $id deleted');
      return true;
    } catch (e) {
      debugPrint('Error deleteUser: $e');
      return false;
    }
  }

  // ==================== VALIDATION ====================

  /// Check if username exists
  Future<bool> isUsernameExists(String username, {int? excludeId}) async {
    try {
      var query =
          _supabase.from('users').select('id_user').eq('username', username);

      if (excludeId != null) {
        query = query.neq('id_user', excludeId);
      }

      final data = await query.limit(1);

      return (data as List).isNotEmpty;
    } catch (e) {
      debugPrint('Error isUsernameExists: $e');
      return false;
    }
  }

  /// Check if user can be deleted
  /// (no active or pending peminjaman)
  Future<bool> canDeleteUser(int idUser) async {
    try {
      // Check for any peminjaman with status != 'selesai' and != 'ditolak'
      final data = await _supabase
          .from('peminjaman')
          .select('id_peminjaman')
          .eq('id_user', idUser)
          .not('status', 'in', '(selesai,ditolak)')
          .limit(1);

      return (data as List).isEmpty;
    } catch (e) {
      debugPrint('Error canDeleteUser: $e');
      return true; // Allow delete if error (conservative approach)
    }
  }

  // ==================== STATISTICS ====================

  /// Count users by role
  Future<Map<String, int>> countUsersByRole() async {
    try {
      final data = await _supabase.from('users').select('role');

      final counts = <String, int>{
        'admin': 0,
        'petugas': 0,
        'peminjam': 0,
      };

      for (var item in data) {
        final role = item['role'] as String;
        counts[role] = (counts[role] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      debugPrint('Error countUsersByRole: $e');
      return {'admin': 0, 'petugas': 0, 'peminjam': 0};
    }
  }

  /// Count total users
  Future<int> countUsers() async {
    try {
      final data = await _supabase.from('users').select();
      return (data as List).length;
    } catch (e) {
      debugPrint('Error countUsers: $e');
      return 0;
    }
  }
}
