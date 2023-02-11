import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/cubit/credit/credit_cubit.dart';
import 'package:movie_time/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:movie_time/cubit/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_time/cubit/on_the_air_series/on_the_air_series_cubit.dart';
import 'package:movie_time/cubit/popular_movie/popular_movie_cubit.dart';
import 'package:movie_time/cubit/recommendation_movie/recommendation_movie_cubit.dart';
import 'package:movie_time/cubit/series_detail/series_detail_cubit.dart';
import 'package:movie_time/cubit/upcoming_movie/upcoming_movie_cubit.dart';
import 'package:movie_time/cubit/watchlist/watchlist_cubit.dart';
import 'package:movie_time/pages/main_page.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/pages/movie/now_playing_movies_page.dart';
import 'package:movie_time/pages/movie/popular_movies_page.dart';
import 'package:movie_time/pages/movie/upcoming_movies_page.dart';
import 'package:movie_time/utilities/constants.dart';

void main() async {
  GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PopularMovieCubit(),
        ),
        BlocProvider(
          create: (context) => NowPlayingMovieCubit(),
        ),
        BlocProvider(
          create: (context) => OnTheAirSeriesCubit(),
        ),
        BlocProvider(
          create: (context) => UpcomingMovieCubit(),
        ),
        BlocProvider(
          create: (context) => MovieDetailCubit(),
        ),
        BlocProvider(
          create: (context) => CreditCubit(),
        ),
        BlocProvider(
          create: (context) => RecommendationMovieCubit(),
        ),
        BlocProvider(
          create: (context) => SeriesDetailCubit(),
        ),
        BlocProvider(
          create: (context) => WatchlistCubit(),
        ),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: bgColorLight1,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: bgColorLight2,
          ),
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          textTheme: TextTheme(
            subtitle2: GoogleFonts.plusJakartaSans(
              color: greyColor,
            ),
          ),
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bgColorDark1,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: bgColorDark2,
          ),
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          textTheme: TextTheme(
            subtitle2: GoogleFonts.plusJakartaSans(
              color: mutedColor,
            ),
          ),
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (lightTheme, darkTheme) => MaterialApp(
          title: 'Movie Time🍿',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          routes: {
            '/': (context) => const MainPage(),
            '/movie/detail': (context) => const MovieDetailPage(),
            '/movie/now-playing': (context) => const NowPlayingMoviesPages(),
            '/movie/popular': (context) => const PopularMoviesPage(),
            '/movie/upcoming': (context) => const UpcomingMoviesPage(),
          },
        ),
      ),
    );
  }
}
