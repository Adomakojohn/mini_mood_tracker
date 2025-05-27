import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/mood_entry.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_state.dart';
import 'bloc/mood/mood_bloc.dart';
import 'bloc/mood/mood_event.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapter
  Hive.registerAdapter(MoodEntryAdapter());

  // Open the Hive box
  final moodBox = await Hive.openBox<MoodEntry>('moods');

  runApp(MyApp(moodBox: moodBox));
}

class MyApp extends StatelessWidget {
  final Box<MoodEntry> moodBox;

  const MyApp({super.key, required this.moodBox});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create: (context) => MoodBloc(moodBox: moodBox)..add(LoadMoods()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Mini Mood Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                (state as ThemeInitial).isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
