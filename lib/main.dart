import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/movie_api_service.dart';
import 'data/datasources/local_storage_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/movie_repository.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/movies/movies_bloc.dart';
import 'logic/watchlist/watchlist_bloc.dart';
import 'presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  final localStorageService = await LocalStorageService.getInstance();
  final movieApiService = MovieApiService();

  final authRepository = AuthRepository(localStorageService);
  final movieRepository = MovieRepository(movieApiService, localStorageService);

  runApp(MyApp(
    authRepository: authRepository,
    movieRepository: movieRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final MovieRepository movieRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.movieRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository),
        ),
        BlocProvider(
          create: (context) => MoviesBloc(movieRepository),
        ),
        BlocProvider(
          create: (context) => WatchlistBloc(movieRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
