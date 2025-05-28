import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/mood/mood_bloc.dart';
import '../bloc/mood/mood_event.dart';
import '../bloc/mood/mood_state.dart';
import '../models/mood_entry.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  // Define mood options with emojis and labels
  static const List<Map<String, String>> moodOptions = [
    {'emoji': '😄', 'label': 'Very Happy', 'mood': 'Very Happy'},
    {'emoji': '😊', 'label': 'Happy', 'mood': 'Happy'},
    {'emoji': '😐', 'label': 'Neutral', 'mood': 'Neutral'},
    {'emoji': '😔', 'label': 'Sad', 'mood': 'Sad'},
    {'emoji': '😢', 'label': 'Very Sad', 'mood': 'Very Sad'},
    {'emoji': '😴', 'label': 'Tired', 'mood': 'Tired'},
    {'emoji': '😤', 'label': 'Angry', 'mood': 'Angry'},
    {'emoji': '😰', 'label': 'Anxious', 'mood': 'Anxious'},
    {'emoji': '🤗', 'label': 'Grateful', 'mood': 'Grateful'},
    {'emoji': '💪', 'label': 'Motivated', 'mood': 'Motivated'},
  ];

  // Function to show mood selection dialog
  void _showMoodSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'How are you feeling?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 moods per row
                childAspectRatio: 2.5, // Make items wider than tall
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: moodOptions.length,
              itemBuilder: (context, index) {
                final moodOption = moodOptions[index];
                return InkWell(
                  onTap: () {
                    _addMood(context, moodOption['mood']!);
                    Navigator.of(context).pop(); // Close dialog
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          moodOption['emoji']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          moodOption['label']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to add a mood entry
  void _addMood(BuildContext context, String mood) {
    final moodEntry = MoodEntry.create(
      mood: mood,
      date: DateTime.now(),
      userId: userId,
    );

    // Add the mood using the MoodBloc
    context.read<MoodBloc>().add(AddMood(moodEntry));

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added mood: $mood'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<MoodBloc, MoodState>(
        builder: (context, state) {
          if (state is MoodLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoodLoaded) {
            // Filter moods for current user using safe getter
            final userMoods =
                state.moods.where((mood) => mood.safeUserId == userId).toList();

            if (userMoods.isEmpty) {
              return const Center(
                child: Text('No moods recorded yet. Add your first mood!'),
              );
            }

            return ListView.builder(
              itemCount: userMoods.length,
              itemBuilder: (context, index) {
                final mood = userMoods[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        _getMoodEmoji(mood.safeMood),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(
                      mood.safeMood,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${mood.safeDate.day}/${mood.safeDate.month}/${mood.safeDate.year} at ${mood.safeDate.hour.toString().padLeft(2, '0')}:${mood.safeDate.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Add delete functionality
                        context.read<MoodBloc>().add(DeleteMood(mood));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mood deleted'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMoodSelectionDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper function to get emoji for a mood
  String _getMoodEmoji(String mood) {
    for (final option in moodOptions) {
      if (option['mood'] == mood) {
        return option['emoji']!;
      }
    }
    return '😐'; // Default emoji if mood not found
  }
}
