import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/cubit/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';

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
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: state.nowPlayingMovie.results.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    customBorder: cardBorderRadius,
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            id: state.nowPlayingMovie.results[index]?.id,
                          ),
                        ),
                      );
                    }),
                    child: Container(
                      width: 102,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        image: DecorationImage(
                          image: state.nowPlayingMovie.results[index]
                                      ?.posterPath !=
                                  null
                              ? NetworkImage(
                                  '${Env.imageBaseURL}w500/${state.nowPlayingMovie.results[index]?.posterPath}',
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
