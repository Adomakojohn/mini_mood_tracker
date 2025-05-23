import 'package:equatable/equatable.dart';
import '../../models/mood_entry.dart';

abstract class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object> get props => [];
}

class MoodInitial extends MoodState {}

class MoodLoading extends MoodState {}

class MoodLoaded extends MoodState {
  final List<MoodEntry> moods;

  const MoodLoaded({required this.moods});

  @override
  List<Object> get props => [moods];
}

class MoodError extends MoodState {
  final String message;

  const MoodError({required this.message});

  @override
  List<Object> get props => [message];
}
