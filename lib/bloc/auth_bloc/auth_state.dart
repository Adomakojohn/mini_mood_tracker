part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

// Initial state when app first loads
final class AuthInitial extends AuthState {}

// State when checking if user is already authenticated
final class AuthLoading extends AuthState {}

// State when user is successfully authenticated
final class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String? name;

  AuthAuthenticated({required this.userId, required this.email, this.name});
}

// State when user is not authenticated (needs to login/signup)
final class AuthUnauthenticated extends AuthState {}

// State when there's an authentication error
final class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
