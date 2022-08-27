import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_time/cubit/movie/movie_cubit.dart';
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
          create: (context) => MovieCubit(),
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
