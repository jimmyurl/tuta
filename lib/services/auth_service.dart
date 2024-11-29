import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<User?> getCurrentUser() async {
    return _supabaseClient.auth.currentUser;
  }

  Future<String?> getUserRole(String userId) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      return response['role'] as String?;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await _supabaseClient
          .from('users')
          .update({'role': newRole}).eq('id', userId);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<bool> isUserSubscribed(String userId) async {
    final role = await getUserRole(userId);
    return role == 'tutor' || role == 'admin';
  }
}
