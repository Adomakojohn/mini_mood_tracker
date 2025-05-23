import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial(isDarkMode: false)) {
    on<ToggleTheme>((event, emit) {
      final currentState = state as ThemeInitial;
      emit(ThemeInitial(isDarkMode: !currentState.isDarkMode));
    });
  }
}
