import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry {
  @HiveField(0)
  final String? mood;

  @HiveField(1)
  final DateTime? date;

  @HiveField(2)
  final String? userId;

  MoodEntry({this.mood, this.date, this.userId});

  String get safeMood => mood ?? 'Unknown';
  DateTime get safeDate => date ?? DateTime.now();
  String get safeUserId => userId ?? '';

  Map<String, dynamic> toJson() {
    return {
      'mood': safeMood,
      'date': safeDate.toIso8601String(),
      'user_id': safeUserId,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      mood: json['mood']?.toString(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      userId: json['user_id']?.toString(),
    );
  }

  factory MoodEntry.create({
    required String mood,
    required DateTime date,
    required String userId,
  }) {
    return MoodEntry(mood: mood, date: date, userId: userId);
  }
}
