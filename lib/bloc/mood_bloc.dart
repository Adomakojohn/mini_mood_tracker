import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mood_event.dart';
part 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc() : super(MoodInitial()) {
    on<MoodEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
