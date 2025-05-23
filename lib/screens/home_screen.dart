import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/mood/mood_bloc.dart';
import '../bloc/mood/mood_event.dart';
import '../bloc/mood/mood_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../models/mood_entry.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> moodOptions = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😌', 'label': 'Calm'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'How are you feeling?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      children:
                          moodOptions.map((mood) {
                            return InkWell(
                              onTap: () {
                                context.read<MoodBloc>().add(
                                  AddMood(
                                    MoodEntry(
                                      mood: '${mood['emoji']} ${mood['label']}',
                                      date: DateTime.now(),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      mood['emoji'],
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                    Text(mood['label']),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<MoodBloc, MoodState>(
              builder: (context, state) {
                if (state is MoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MoodLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.moods.length,
                    itemBuilder: (context, index) {
                      final mood = state.moods[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(mood.mood),
                          subtitle: Text(
                            '${mood.date.day}/${mood.date.month}/${mood.date.year} ${mood.date.hour}:${mood.date.minute}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<MoodBloc>().add(DeleteMood(mood));
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                if (state is MoodError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('Select your mood'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
