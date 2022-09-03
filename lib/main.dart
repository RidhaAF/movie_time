import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_time/cubit/credit/credit_cubit.dart';
import 'package:movie_time/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:movie_time/cubit/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_time/cubit/on_the_air_series/on_the_air_series_cubit.dart';
import 'package:movie_time/cubit/popular_movie/popular_movie_cubit.dart';
import 'package:movie_time/cubit/recommendation_movie/recommendation_movie_cubit.dart';
import 'package:movie_time/cubit/series_detail/series_detail_cubit.dart';
import 'package:movie_time/cubit/upcoming_movie/upcoming_movie_cubit.dart';
import 'package:movie_time/pages/main_page.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/pages/movie/now_playing_movies_page.dart';
import 'package:movie_time/pages/movie/popular_movies_page.dart';
import 'package:movie_time/pages/movie/upcoming_movies_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      ],
      child: MaterialApp(
        title: 'Movie Time🍿',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const MainPage(),
          '/movie/detail': (context) => const MovieDetailPage(),
          '/movie/now-playing': (context) => const NowPlayingMoviesPages(),
          '/movie/popular': (context) => const PopularMoviesPage(),
          '/movie/upcoming': (context) => const UpcomingMoviesPage(),
        },
      ),
    );
  }
}
