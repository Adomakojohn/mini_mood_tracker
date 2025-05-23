import 'package:equatable/equatable.dart';
import '../../models/mood_entry.dart';

abstract class MoodEvent extends Equatable {
  const MoodEvent();

  @override
  List<Object> get props => [];
}

class AddMood extends MoodEvent {
  final MoodEntry moodEntry;

  const AddMood(this.moodEntry);

  @override
  List<Object> get props => [moodEntry];
}

class LoadMoods extends MoodEvent {}

class DeleteMood extends MoodEvent {
  final MoodEntry moodEntry;

  const DeleteMood(this.moodEntry);

  @override
  List<Object> get props => [moodEntry];
}
