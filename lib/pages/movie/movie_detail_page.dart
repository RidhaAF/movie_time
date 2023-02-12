import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/cubit/credit/credit_cubit.dart';
import 'package:movie_time/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:movie_time/cubit/recommendation_movie/recommendation_movie_cubit.dart';
import 'package:movie_time/cubit/watchlist/watchlist_cubit.dart';
import 'package:movie_time/models/movie_detail_model.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';
import 'package:readmore/readmore.dart';

class MovieDetailPage extends StatefulWidget {
  final int? id;
  const MovieDetailPage({Key? key, this.id}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late MovieDetailModel movie;
  String title = '';
  bool isWatchlist = false;
  var top = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<MovieDetailCubit>().getMovieDetail(widget.id ?? 0);
    context.read<CreditCubit>().getCredits(widget.id ?? 0);
    context
        .read<RecommendationMovieCubit>()
        .getRecommendationMovie(widget.id ?? 0);
    if (context.read<WatchlistCubit>().getWatchlistData() != null) {
      List watchlist = context.read<WatchlistCubit>().getWatchlistData() ?? [];
      for (Map item in watchlist) {
        if (item['id'] == widget.id) {
          setState(() {
            isWatchlist = true;
          });
        }
      }
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<MovieDetailCubit>().getMovieDetail(widget.id ?? 0);
      context.read<CreditCubit>().getCredits(widget.id ?? 0);
      context
          .read<RecommendationMovieCubit>()
          .getRecommendationMovie(widget.id ?? 0);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailInitial) {
              return Container();
            } else if (state is MovieDetailLoading) {
              return loadingIndicator();
            } else if (state is MovieDetailLoaded) {
              movie = state.movieDetail;
              title = movie.originalLanguage == 'id'
                  ? movie.originalTitle ?? ''
                  : movie.title ?? '';
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 200,
                    backgroundColor: primaryColor,
                    centerTitle: true,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: defaultMargin),
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: whiteColor,
                          size: 32,
                          semanticLabel: 'Back',
                        ),
                      ),
                    ),
                    leadingWidth: 48,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isWatchlist = !isWatchlist;

                            isWatchlist
                                ? context
                                    .read<WatchlistCubit>()
                                    .addToWatchlist(movie: movie.toJson())
                                : context
                                    .read<WatchlistCubit>()
                                    .removeFromWatchlist(movie: movie.toJson());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    isWatchlist ? Colors.green : primaryColor,
                                content: Text(
                                  isWatchlist
                                      ? 'Added to Watchlist'
                                      : 'Removed from Watchlist',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: whiteColor,
                                    fontWeight: bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            isWatchlist = !isWatchlist;
                            context.read<WatchlistCubit>().clearWatchlist();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: defaultMargin),
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isWatchlist == false
                                ? Icons.bookmark_outline
                                : Icons.bookmark_outlined,
                            semanticLabel: 'Add to Watchlist',
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      top = constraints.biggest.height;
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: top <= 130.0 ? 1.0 : 0.0,
                          child: Text(
                            title.length > 25
                                ? '${title.substring(0, 25)}...'
                                : title,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        collapseMode: CollapseMode.parallax,
                        background: movieBackground(movie),
                      );
                    }),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: EdgeInsets.all(defaultMargin),
                          child: Row(
                            children: [
                              moviePoster(movie),
                              SizedBox(width: defaultMargin),
                              movieInfo(movie),
                            ],
                          ),
                        ),
                        movieOverview(movie),
                        SizedBox(height: defaultMargin),
                        movieRating(movie),
                        SizedBox(height: defaultMargin),
                        movieCast(),
                        movieRecommendation(),
                        SizedBox(height: defaultMargin),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget movieBackground(MovieDetailModel? movie) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryColor,
        image: DecorationImage(
          colorFilter:
              ColorFilter.mode(blackColor.withOpacity(0.3), BlendMode.darken),
          image: movie?.backdropPath != null
              ? NetworkImage(
                  '${Env.imageBaseURL}original/${movie?.backdropPath}',
                )
              : const AssetImage('assets/images/img_null.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget moviePoster(MovieDetailModel? movie) {
    return Container(
      height: 154,
      width: 102,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(defaultRadius),
        image: DecorationImage(
          image: movie?.posterPath != null
              ? NetworkImage(
                  '${Env.imageBaseURL}original/${movie?.posterPath}',
                )
              : const AssetImage('assets/images/img_null.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget movieInfo(MovieDetailModel? movie) {
    String? certification;
    String? certificationWithDot;

    for (Country country in movie!.releases!.countries ?? []) {
      if (country.iso31661 == 'US') {
        certification = country.certification ?? '';
      }
    }

    if (certification != null && certification != '') {
      certificationWithDot = '$certification • ';
    } else {
      certificationWithDot = '';
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: title2FS,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${movie.releaseDate?.toString().substring(0, 4)} • $certificationWithDot${movie.runtime ?? 0} mins',
            style: GoogleFonts.plusJakartaSans(
              fontSize: footnoteFS,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Genre ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: caption1FS,
                ),
              ),
              Expanded(
                child: Text(
                  movie.genres?.map((genre) => genre.name).join(', ') ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: footnoteFS,
                    fontWeight: semiBold,
                  ),
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<CreditCubit, CreditState>(
            builder: (context, state) {
              if (state is CreditLoaded) {
                return Row(
                  children: [
                    Text(
                      'Director ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: caption1FS,
                      ),
                    ),
                    Text(
                      // find all directors
                      state.credit.crew
                              ?.where((crew) => crew.job == 'Director')
                              .map((crew) => crew.name)
                              .join(', ') ??
                          '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: footnoteFS,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget movieOverview(MovieDetailModel? movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: GoogleFonts.plusJakartaSans(
              fontSize: title3FS,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 8),
          ReadMoreText(
            movie?.overview ?? '',
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.justify,
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimCollapsedText: '... read more',
            trimExpandedText: ' show less',
            delimiter: '',
            lessStyle: GoogleFonts.plusJakartaSans(
              color: primaryColor,
              fontSize: bodyFS,
              fontWeight: semiBold,
            ),
            moreStyle: GoogleFonts.plusJakartaSans(
              color: primaryColor,
              fontSize: bodyFS,
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget movieRating(MovieDetailModel? movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.star_rounded,
            color: yellowColor,
          ),
          const SizedBox(width: 4),
          Text(
            movie?.voteAverage?.toStringAsFixed(1) ?? '',
            style: GoogleFonts.plusJakartaSans(
              fontSize: headlineFS,
              fontWeight: bold,
            ),
          ),
          Text(
            '/10 • ${movie?.voteCount.toString()}',
            style: GoogleFonts.plusJakartaSans(
              color: mutedColor,
              fontSize: caption1FS,
            ),
          ),
        ],
      ),
    );
  }

  Widget movieCast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Text(
            'Cast',
            style: GoogleFonts.plusJakartaSans(
              fontSize: title3FS,
              fontWeight: bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          height: 152,
          child: BlocBuilder<CreditCubit, CreditState>(
            builder: (context, state) {
              if (state is CreditLoaded) {
                return ListView.builder(
                  padding: EdgeInsets.only(left: defaultMargin, right: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.credit.cast?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: state.credit.cast?[index].profilePath !=
                                        null
                                    ? NetworkImage(
                                        '${Env.imageBaseURL}w500/${state.credit.cast?[index].profilePath}',
                                      )
                                    : const AssetImage(
                                            'assets/images/img_null.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              state.credit.cast?[index].name ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: caption1FS,
                                fontWeight: bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              state.credit.cast?[index].character ?? '',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: caption1FS,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget movieRecommendation() {
    return BlocBuilder<RecommendationMovieCubit, RecommendationMovieState>(
      builder: (context, state) {
        if (state is RecommendationMovieLoaded) {
          return Container(
            margin: EdgeInsets.only(bottom: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(defaultMargin, 8, defaultMargin, 8),
                  child: Text(
                    'Recommendation',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: title3FS,
                      fontWeight: bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 154,
                  width: double.infinity,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: defaultMargin, right: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.recommendationMovie.results.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          customBorder: cardBorderRadius,
                          onTap: (() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(
                                  id: state
                                      .recommendationMovie.results[index]?.id,
                                ),
                              ),
                            );
                          }),
                          child: Container(
                            width: 102,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              image: DecorationImage(
                                image: state.recommendationMovie.results[index]
                                            ?.posterPath !=
                                        null
                                    ? NetworkImage(
                                        '${Env.imageBaseURL}w500/${state.recommendationMovie.results[index]?.posterPath}',
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
            ),
          );
        }
        return Container();
      },
    );
  }
}
