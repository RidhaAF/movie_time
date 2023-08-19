import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/cubit/aggregate_credit/aggregate_credit_cubit.dart';
import 'package:movie_time/cubit/credit/credit_cubit.dart';
import 'package:movie_time/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:movie_time/cubit/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_time/cubit/on_the_air_series/on_the_air_series_cubit.dart';
import 'package:movie_time/cubit/popular_movie/popular_movie_cubit.dart';
import 'package:movie_time/cubit/recommendation_movie/recommendation_movie_cubit.dart';
import 'package:movie_time/cubit/recommendation_series/recommendation_series_cubit.dart';
import 'package:movie_time/cubit/search/search_cubit.dart';
import 'package:movie_time/cubit/series_detail/series_detail_cubit.dart';
import 'package:movie_time/cubit/series_season_detail/series_season_detail_cubit.dart';
import 'package:movie_time/cubit/upcoming_movie/upcoming_movie_cubit.dart';
import 'package:movie_time/cubit/user/user_cubit.dart';
import 'package:movie_time/cubit/watchlist/watchlist_cubit.dart';
import 'package:movie_time/firebase_options.dart';
import 'package:movie_time/pages/auth/sign_in_page.dart';
import 'package:movie_time/pages/main_page.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/pages/movie/now_playing_movies_page.dart';
import 'package:movie_time/pages/movie/popular_movies_page.dart';
import 'package:movie_time/pages/movie/upcoming_movies_page.dart';
import 'package:movie_time/pages/profile/profile_page.dart';
import 'package:movie_time/pages/search/search_page.dart';
import 'package:movie_time/pages/series/on_the_air_series_page.dart';
import 'package:movie_time/pages/series/series_detail_page.dart';
import 'package:movie_time/pages/watchlist/watchlist_page.dart';
import 'package:movie_time/utilities/constants.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

String getInitialRoute() {
  final box = GetStorage();
  if (box.read('isLogin') == true && box.read('token') != null) {
    return '/';
  } else {
    return '/sign-in';
  }
}

final _router = GoRouter(
  initialLocation: getInitialRoute(),
  routes: [
    GoRoute(
      name: 'sign-in',
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      name: 'search',
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      name: 'watchlist',
      path: '/watchlist',
      builder: (context, state) => const WatchlistPage(),
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      name: 'movie-now-playing',
      path: '/movie/now-playing',
      builder: (context, state) => const NowPlayingMoviesPages(),
    ),
    GoRoute(
      name: 'movie-popular',
      path: '/movie/popular',
      builder: (context, state) => const PopularMoviesPage(),
    ),
    GoRoute(
      name: 'movie-upcoming',
      path: '/movie/upcoming',
      builder: (context, state) => const UpcomingMoviesPage(),
    ),
    GoRoute(
      name: 'movie-detail',
      path: '/movie/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id'].toString());
        return MovieDetailPage(id: id);
      },
    ),
    GoRoute(
      name: 'series-on-the-air',
      path: '/series/on-the-air',
      builder: (context, state) => const OnTheAirSeriesPage(),
    ),
    GoRoute(
      name: 'series-detail',
      path: '/series/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id'].toString());
        return SeriesDetailPage(id: id);
      },
    ),
  ],
);

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
          create: (context) => SeriesSeasonDetailCubit(),
        ),
        BlocProvider(
          create: (context) => AggregateCreditCubit(),
        ),
        BlocProvider(
          create: (context) => RecommendationSeriesCubit(),
        ),
        BlocProvider(
          create: (context) => WatchlistCubit(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
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
            titleSmall: GoogleFonts.plusJakartaSans(
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
            titleSmall: GoogleFonts.plusJakartaSans(
              color: mutedColor,
            ),
          ),
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (lightTheme, darkTheme) => MaterialApp.router(
          title: 'Movie Time🍿',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: _router,
        ),
      ),
    );
  }
}
