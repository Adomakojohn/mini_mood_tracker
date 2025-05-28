import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  // Check if user is currently authenticated
  User? get currentUser => _supabase.auth.currentUser;

  // Get current user as UserModel
  UserModel? get currentUserModel {
    try {
      final user = currentUser;
      if (user == null) return null;

      // Get name from metadata
      final name = user.userMetadata?['name']?.toString();

      return UserModel.fromSupabase(user, displayName: name);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Listen to authentication state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw Exception('All fields are required');
      }

      final response = await _supabase.auth
          .signUp(
            email: email,
            password: password,
            data: {'name': name}, // Store name in user metadata
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Sign up timed out'),
          );

      if (response.user == null) {
        throw Exception('Failed to create account');
      }

      return UserModel.fromSupabase(response.user!, displayName: name);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Sign in timed out'),
          );

      if (response.user == null) {
        throw Exception('Failed to sign in');
      }

      // Get name from metadata
      final name = response.user?.userMetadata?['name']?.toString();

      return UserModel.fromSupabase(response.user!, displayName: name);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Sign out timed out'),
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email is required');
      }

      await _supabase.auth
          .resetPasswordForEmail(email)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Password reset timed out'),
          );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
