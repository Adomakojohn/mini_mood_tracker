part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthCheckRequested extends AuthEvent {}

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

final class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

final class SignOutRequested extends AuthEvent {}
