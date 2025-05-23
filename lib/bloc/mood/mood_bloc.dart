import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/mood_entry.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final Box<MoodEntry> moodBox;

  MoodBloc({required this.moodBox}) : super(MoodInitial()) {
    on<LoadMoods>(_onLoadMoods);
    on<AddMood>(_onAddMood);
    on<DeleteMood>(_onDeleteMood);
  }

  void _onLoadMoods(LoadMoods event, Emitter<MoodState> emit) async {
    try {
      emit(MoodLoading());
      final moods = moodBox.values.toList();
      moods.sort(
        (a, b) => b.date.compareTo(a.date),
      ); // Sort by date, newest first
      emit(MoodLoaded(moods: moods));
    } catch (e) {
      emit(MoodError(message: 'Failed to load moods: $e'));
    }
  }

  void _onAddMood(AddMood event, Emitter<MoodState> emit) async {
    try {
      await moodBox.add(event.moodEntry);
      final moods = moodBox.values.toList();
      moods.sort((a, b) => b.date.compareTo(a.date));
      emit(MoodLoaded(moods: moods));
    } catch (e) {
      emit(MoodError(message: 'Failed to add mood: $e'));
    }
  }

  void _onDeleteMood(DeleteMood event, Emitter<MoodState> emit) async {
    try {
      final index = moodBox.values.toList().indexOf(event.moodEntry);
      await moodBox.deleteAt(index);
      final moods = moodBox.values.toList();
      moods.sort((a, b) => b.date.compareTo(a.date));
      emit(MoodLoaded(moods: moods));
    } catch (e) {
      emit(MoodError(message: 'Failed to delete mood: $e'));
    }
  }
}
