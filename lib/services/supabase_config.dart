import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://qrvxdlurbfywofsuhioo.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFydnhkbHVyYmZ5d29mc3VoaW9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0NzMyNjMsImV4cCI6MjA3MzA0OTI2M30.TOaJipxULCD7b6A-NbnvgsSGUG9630_QXkhU1GSJv44';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
static SupabaseClient get client => Supabase.instance.client;

}
