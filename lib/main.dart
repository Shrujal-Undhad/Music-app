import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/controllers/Library_controller.dart';
import 'package:musicapp/controllers/favorite_songs_Controller.dart';
import 'package:musicapp/controllers/genre_chip_controller.dart';
import 'package:musicapp/controllers/myaudioplayer.dart';
import 'package:musicapp/controllers/profile_controller.dart';
import 'package:musicapp/models/song.dart';
import 'package:musicapp/models/user_data.dart';
import 'package:provider/provider.dart';
import 'controllers/album_controller.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/api_service.dart';
import 'services/auth.dart';
import 'controllers/song_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SongProvider()),
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteSongsProvider()),
        ChangeNotifierProvider(create: (context) => GenreChipProvider()),
        ChangeNotifierProvider(
          create: (context) => MyAudioPlayerProvider(
            Provider.of<SongProvider>(context, listen: false),
          ),
        ),
        // ChangeNotifierProvider(create: (_) => UserData()),
        // ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context);

    return StreamBuilder<AuthStatus>(
      stream: authService.statusStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else if (snapshot.hasError) {
          return ErrorScreen(error: 'An unexpected error occurred');
        } else if (snapshot.data == AuthStatus.authenticated) {
          return MainScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Object? error;

  ErrorScreen({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('An error occurred: $error')),
    );
  }
}
