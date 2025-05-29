import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/mood_entry.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_state.dart';
import 'bloc/mood/mood_bloc.dart';
import 'bloc/mood/mood_event.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'theme/app_theme.dart';
import 'screens/auth_wrapper.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env");

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception(
        'Missing Supabase configuration. Please check your .env file contains SUPABASE_URL and SUPABASE_ANON_KEY',
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Failed to initialize Supabase'),
    );

    // Initialize Hive
    await Hive.initFlutter();

    // Register Hive Adapter
    Hive.registerAdapter(MoodEntryAdapter());

    try {
      await Hive.deleteBoxFromDisk('moods');
    } catch (e) {
      print('Note: Could not clear existing mood data: $e');
    }

    // Open the Hive box
    final moodBox = await Hive.openBox<MoodEntry>('moods');

    // Create Supabase client
    final supabase = Supabase.instance.client;

    final authRepository = AuthRepository(supabase: supabase);

    runApp(MyApp(moodBox: moodBox, authRepository: authRepository));
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
                const SizedBox(height: 16),
                Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final Box<MoodEntry> moodBox;
  final AuthRepository authRepository;

  const MyApp({super.key, required this.moodBox, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(authRepository: authRepository)
                    ..add(AuthCheckRequested()),
        ),
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
            home: AuthWrapper(),
          );
        },
      ),
    );
  }
}
