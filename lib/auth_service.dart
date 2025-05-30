import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //sign in
  Future<AuthResponse> signInWithEmailPassword(
    String email, String password) async {
      return await _supabase.auth.signInWithPassword(password: password, email: email);
    }

  //sign up
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signUp(password: password, email: email);
  }

  //sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  //get user email
}