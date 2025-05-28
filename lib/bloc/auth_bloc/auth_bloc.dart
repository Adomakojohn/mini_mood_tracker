import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    // Handle checking if user is already authenticated
    on<AuthCheckRequested>(_onAuthCheckRequested);

    // Handle sign up requests
    on<SignUpRequested>(_onSignUpRequested);

    // Handle sign in requests
    on<SignInRequested>(_onSignInRequested);

    // Handle sign out requests
    on<SignOutRequested>(_onSignOutRequested);
  }

  // Check if user is already authenticated when app starts
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = _authRepository.currentUserModel;

      if (user != null) {
        // User is already authenticated
        emit(
          AuthAuthenticated(
            userId: user.id,
            email: user.email,
            name: user.name,
          ),
        );
      } else {
        // User is not authenticated
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check authentication status'));
    }
  }

  // Handle sign up requests
  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      emit(
        AuthAuthenticated(userId: user.id, email: user.email, name: user.name),
      );
    } catch (e) {
      emit(AuthError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Handle sign in requests
  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );

      emit(
        AuthAuthenticated(userId: user.id, email: user.email, name: user.name),
      );
    } catch (e) {
      emit(AuthError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Handle sign out requests
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
