import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/cubit/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_time/cubit/on_the_air_series/on_the_air_series_cubit.dart';
import 'package:movie_time/cubit/popular_movie/popular_movie_cubit.dart';
import 'package:movie_time/cubit/upcoming_movie/upcoming_movie_cubit.dart';
import 'package:movie_time/models/now_playing_movie_model.dart' as npm;
import 'package:movie_time/models/on_the_air_series_model.dart' as otasm;
import 'package:movie_time/models/popular_movie_model.dart' as pmm;
import 'package:movie_time/models/upcoming_movie_model.dart' as umm;
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';
import 'package:movie_time/utilities/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _getData();
      setState(() {});
    }
  }

  _getData() {
    context.read<NowPlayingMovieCubit>().getNowPlayingMovies();
    context.read<PopularMovieCubit>().getPopularMovies();
    context.read<OnTheAirSeriesCubit>().getOnTheAirSeries();
    context.read<UpcomingMovieCubit>().getUpcomingMovies();
  }

  _goToMovieDetail(int id) {
    context.push('/movie/detail/$id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Movie Time🍿',
        style: GoogleFonts.plusJakartaSans(
          fontSize: title2FS,
          fontWeight: bold,
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: defaultMargin),
              child: Column(
                children: [
                  sliderImage(),
                  nowPlayingMovies(),
                  onTheAirSeries(),
                  popular(),
                  upcoming(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sliderImage() {
    return BlocBuilder<PopularMovieCubit, PopularMovieState>(
      builder: (context, state) {
        if (state is PopularMovieInitial) {
          return Container();
        } else if (state is PopularMovieLoading) {
          return sliderMoviePosterShimmer(context);
        } else if (state is PopularMovieLoaded) {
          List<pmm.Result?> popularMovies = state.popularMovie.results;

          return Column(
            children: [
              CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  pmm.Result? movie = popularMovies[index];
                  int? id = movie?.id ?? 0;

                  return Container(
                    margin: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                    child: InkWell(
                      customBorder: cardBorderRadius,
                      onTap: (() {
                        _goToMovieDetail(id);
                      }),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${Env.imageBaseURL}original/${movie?.backdropPath}',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(defaultRadius),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          color: getContainerColor(context),
                        ),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/img_null.png'),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  viewportFraction: 0.95,
                  autoPlayInterval: const Duration(seconds: 5),
                  onPageChanged: (index, carouselReason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                carouselController: _carouselController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(index),
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? primaryColor : mutedColor,
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget nowPlayingMovies() {
    return BlocBuilder<NowPlayingMovieCubit, NowPlayingMovieState>(
      builder: (context, state) {
        if (state is NowPlayingMovieInitial) {
          return Container();
        } else if (state is NowPlayingMovieLoading) {
          return moviePosterShimmer(context);
        } else if (state is NowPlayingMovieLoaded) {
          List<npm.Result?> nowPlayingMovies = state.nowPlayingMovie.results;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    defaultMargin, defaultMargin, defaultMargin, 8),
                child: InkWell(
                  onTap: () {
                    context.push('/movie/now-playing');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Now Playing Movies',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: title3FS,
                          fontWeight: bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 154,
                width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: defaultMargin, right: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    npm.Result? movie = nowPlayingMovies[index];
                    int? id = movie?.id ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        customBorder: cardBorderRadius,
                        onTap: (() {
                          _goToMovieDetail(id);
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
                                  : const AssetImage(
                                          'assets/images/img_null.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(defaultRadius),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget onTheAirSeries() {
    return BlocBuilder<OnTheAirSeriesCubit, OnTheAirSeriesState>(
      builder: (context, state) {
        if (state is OnTheAirSeriesInitial) {
          return Container();
        } else if (state is OnTheAirSeriesLoading) {
          return moviePosterShimmer(context);
        } else if (state is OnTheAirSeriesLoaded) {
          List<otasm.Result?> onTheAirSeries = state.onTheAirSeries.results;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    defaultMargin, defaultMargin, defaultMargin, 8),
                child: InkWell(
                  onTap: () {
                    context.push('/series/on-the-air');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'On The Air Series',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: title3FS,
                          fontWeight: bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 154,
                width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: defaultMargin, right: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    otasm.Result? series = onTheAirSeries[index];
                    int? id = series?.id ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        customBorder: cardBorderRadius,
                        onTap: (() {
                          context.push('/series/detail/$id');
                        }),
                        child: Container(
                          width: 102,
                          decoration: BoxDecoration(
                            color: getContainerColor(context),
                            image: DecorationImage(
                              image: series?.posterPath != null
                                  ? NetworkImage(
                                      '${Env.imageBaseURL}w500/${series?.posterPath}',
                                    )
                                  : const AssetImage(
                                          'assets/images/img_null.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(defaultRadius),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget popular() {
    return BlocBuilder<PopularMovieCubit, PopularMovieState>(
      builder: (context, state) {
        if (state is PopularMovieInitial) {
          return Container();
        } else if (state is PopularMovieLoading) {
          return moviePosterShimmer(context);
        } else if (state is PopularMovieLoaded) {
          List<pmm.Result?> popularMovies = state.popularMovie.results;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    defaultMargin, defaultMargin, defaultMargin, 8),
                child: InkWell(
                  onTap: () {
                    context.push('/movie/popular');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: title3FS,
                          fontWeight: bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 154,
                width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: defaultMargin, right: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    pmm.Result? movie = popularMovies[index];
                    int? id = movie?.id ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        customBorder: cardBorderRadius,
                        onTap: (() {
                          _goToMovieDetail(id);
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
                                  : const AssetImage(
                                          'assets/images/img_null.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(defaultRadius),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget upcoming() {
    return BlocBuilder<UpcomingMovieCubit, UpcomingMovieState>(
      builder: (context, state) {
        if (state is UpcomingMovieInitial) {
          return Container();
        } else if (state is UpcomingMovieLoading) {
          return moviePosterShimmer(context);
        } else if (state is UpcomingMovieLoaded) {
          List<umm.Result?> upcomingMovies = state.upcomingMovie.results;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    defaultMargin, defaultMargin, defaultMargin, 8),
                child: InkWell(
                  onTap: () {
                    context.push('/movie/upcoming');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: title3FS,
                          fontWeight: bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 154,
                width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: defaultMargin, right: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: upcomingMovies.length,
                  itemBuilder: (context, index) {
                    umm.Result? movie = upcomingMovies[index];
                    int? id = movie?.id ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        customBorder: cardBorderRadius,
                        onTap: (() {
                          _goToMovieDetail(id);
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
                                  : const AssetImage(
                                          'assets/images/img_null.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(defaultRadius),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
