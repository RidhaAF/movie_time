import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/components/vertical_poster.dart';
import 'package:movie_time/cubit/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_time/models/now_playing_movie_model.dart';
import 'package:movie_time/utilities/constants.dart';

class NowPlayingMoviesPages extends StatefulWidget {
  const NowPlayingMoviesPages({super.key});

  @override
  State<NowPlayingMoviesPages> createState() => _NowPlayingMoviesPagesState();
}

class _NowPlayingMoviesPagesState extends State<NowPlayingMoviesPages> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<NowPlayingMovieCubit>().getNowPlayingMovies();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Now Playing Movies',
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<NowPlayingMovieCubit, NowPlayingMovieState>(
          builder: (context, state) {
            if (state is NowPlayingMovieInitial) {
              return Container();
            } else if (state is NowPlayingMovieLoading) {
              return gridMoviePosterShimmer(context);
            } else if (state is NowPlayingMovieLoaded) {
              List<Result?> nowPlayingMovies = state.nowPlayingMovie.results;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: nowPlayingMovies.length,
                itemBuilder: (context, index) {
                  Result? movie = nowPlayingMovies[index];
                  int? id = movie?.id ?? 0;

                  return InkWell(
                    customBorder: cardBorderRadius,
                    onTap: (() {
                      context.push('/movie/detail/$id');
                    }),
                    child: VerticalPoster(posterPath: movie?.posterPath),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
