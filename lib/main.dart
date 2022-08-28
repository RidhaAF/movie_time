import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_time/cubit/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_time/cubit/on_the_air_series/on_the_air_series_cubit.dart';
import 'package:movie_time/cubit/popular_movie/popular_movie_cubit.dart';
import 'package:movie_time/pages/main_page.dart';

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
      ],
      child: const MaterialApp(
        title: 'Movie Time🍿',
        home: MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
