import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/mood/mood_bloc.dart';
import '../bloc/mood/mood_event.dart';
import '../bloc/mood/mood_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../models/mood_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isHistoryVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> moodOptions = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😍', 'label': 'Love'},
    {'emoji': '😰', 'label': 'Anxious'},
    {'emoji': '🤔', 'label': 'Thoughtful'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleHistory() {
    setState(() {
      _isHistoryVisible = !_isHistoryVisible;
      if (_isHistoryVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

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
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'How are you feeling?',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                    itemCount: moodOptions.length,
                    itemBuilder: (context, index) {
                      final mood = moodOptions[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            context.read<MoodBloc>().add(
                              AddMood(
                                MoodEntry(
                                  mood: '${mood['emoji']} ${mood['label']}',
                                  date: DateTime.now(),
                                ),
                              ),
                            );
                            if (!_isHistoryVisible) {
                              _toggleHistory();
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  mood['emoji'],
                                  style: const TextStyle(fontSize: 48),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  mood['label'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Add padding at the bottom to ensure content isn't hidden behind the history panel
                SizedBox(
                  height:
                      _isHistoryVisible
                          ? MediaQuery.of(context).size.height * 0.6
                          : 20,
                ),
              ],
            ),
          ),
          // Dismiss detector for the history panel
          if (_isHistoryVisible)
            GestureDetector(
              onTap: _toggleHistory,
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          // History Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom:
                _isHistoryVisible
                    ? 0
                    : -(MediaQuery.of(context).size.height * 0.6),
            child: GestureDetector(
              onTap: () {}, // Prevent taps from reaching the background
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleHistory,
                      child: Container(
                        width: 60,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mood History',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 32,
                            ),
                            onPressed: _toggleHistory,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<MoodBloc, MoodState>(
                        builder: (context, state) {
                          if (state is MoodLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is MoodLoaded) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: state.moods.length,
                              itemBuilder: (context, index) {
                                final mood = state.moods[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(
                                      mood.mood,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '${mood.date.day}/${mood.date.month}/${mood.date.year} ${mood.date.hour}:${mood.date.minute}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, size: 28),
                                      onPressed: () {
                                        context.read<MoodBloc>().add(
                                          DeleteMood(mood),
                                        );
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
                          return const Center(
                            child: Text(
                              'Select your mood',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
