part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// Event triggered when app starts to check if user is already logged in
final class AuthCheckRequested extends AuthEvent {}

// Event triggered when user wants to sign up with email/password
final class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });
}

// Event triggered when user wants to sign in with email/password
final class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

// Event triggered when user wants to sign out
final class SignOutRequested extends AuthEvent {}
