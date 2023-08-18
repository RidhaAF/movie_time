import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/cubit/upcoming_movie/upcoming_movie_cubit.dart';
import 'package:movie_time/models/upcoming_movie_model.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';
import 'package:movie_time/utilities/functions.dart';

class UpcomingMoviesPage extends StatefulWidget {
  const UpcomingMoviesPage({super.key});

  @override
  State<UpcomingMoviesPage> createState() => _UpcomingMoviesPageState();
}

class _UpcomingMoviesPageState extends State<UpcomingMoviesPage> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<UpcomingMovieCubit>().getUpcomingMovies();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Upcoming',
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<UpcomingMovieCubit, UpcomingMovieState>(
          builder: (context, state) {
            if (state is UpcomingMovieInitial) {
              return Container();
            } else if (state is UpcomingMovieLoading) {
              return gridMoviePosterShimmer(context);
            } else if (state is UpcomingMovieLoaded) {
              List<Result?> upcomingMovies = state.upcomingMovie.results;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: upcomingMovies.length,
                itemBuilder: (context, index) {
                  Result? movie = upcomingMovies[index];
                  int? id = movie?.id ?? 0;

                  return InkWell(
                    customBorder: cardBorderRadius,
                    onTap: (() {
                      context.push('/movie/detail/$id');
                    }),
                    child: Container(
                      width: 102,
                      decoration: BoxDecoration(
                        color: getContainerColor(context),
                        image: DecorationImage(
                          image: movie?.posterPath != null
                              ? NetworkImage(
                                  '${Env.imageBaseURL}w500/${movie?.posterPath}',
                                )
                              : const AssetImage('assets/images/img_null.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultRadius),
                        ),
                      ),
                    ),
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
