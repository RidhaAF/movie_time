import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/components/vertical_poster.dart';
import 'package:movie_time/cubit/popular_movie/popular_movie_cubit.dart';
import 'package:movie_time/models/popular_movie_model.dart';
import 'package:movie_time/utilities/constants.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<PopularMovieCubit>().getPopularMovies();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Popular',
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<PopularMovieCubit, PopularMovieState>(
          builder: (context, state) {
            if (state is PopularMovieInitial) {
              return Container();
            } else if (state is PopularMovieLoading) {
              return gridMoviePosterShimmer(context);
            } else if (state is PopularMovieLoaded) {
              List<Result?> popularMovies = state.popularMovie.results;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: popularMovies.length,
                itemBuilder: (context, index) {
                  Result? movie = popularMovies[index];
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
