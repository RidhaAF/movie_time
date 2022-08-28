import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/cubit/credit/credit_cubit.dart';
import 'package:movie_time/cubit/movie_detail/movie_detail_cubit.dart';
import 'package:movie_time/cubit/recommendation_movie/recommendation_movie_cubit.dart';
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
      backgroundColor: bgColorLight1,
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailInitial) {
              return Container();
            } else if (state is MovieDetailLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: primaryColor,
                    ),
                    SizedBox(height: defaultMargin),
                    Text(
                      'Loading',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: title3FS,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is MovieDetailLoaded) {
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
                            state.movieDetail.title ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        collapseMode: CollapseMode.parallax,
                        background: movieBackground(state.movieDetail),
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
                              moviePoster(state.movieDetail),
                              const SizedBox(width: 8),
                              movieInfo(state.movieDetail),
                            ],
                          ),
                        ),
                        movieOverview(state.movieDetail),
                        const SizedBox(height: 16),
                        movieRating(state.movieDetail),
                        const SizedBox(height: 16),
                        movieCast(),
                        movieRecommendation(),
                        const SizedBox(height: 16),
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
}

Widget movieBackground(MovieDetailModel? movie) {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      color: secondaryColor,
      image: DecorationImage(
        colorFilter:
            ColorFilter.mode(blackColor.withOpacity(0.5), BlendMode.darken),
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
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie?.originalLanguage == 'id'
              ? movie?.originalTitle ?? ''
              : movie?.title ?? '',
          style: GoogleFonts.plusJakartaSans(
            fontSize: title3FS,
            fontWeight: bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${movie?.releaseDate?.toString().substring(0, 4)} • ${movie?.runtime ?? 0} min',
          style: GoogleFonts.plusJakartaSans(
            fontSize: subheadlineFS,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Genre ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: subheadlineFS,
              ),
            ),
            Expanded(
              child: Text(
                movie?.genres?.map((genre) => genre.name).join(', ') ?? '',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: subheadlineFS,
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
                      fontSize: subheadlineFS,
                    ),
                  ),
                  Text(
                    state.credit.crew
                            ?.firstWhere((crew) => crew.job == 'Director')
                            .name ??
                        '',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: subheadlineFS,
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: bodyFS,
          ),
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

Widget castList() {
  return BlocBuilder<CreditCubit, CreditState>(
    builder: (context, state) {
      if (state is CreditLoaded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://www.themoviedb.org/t/p/w138_and_h175_face/phSALdB5EwWbDp2bsrYe5i6PlYP.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Timothée Chalamet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Paul Atreides',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      }
      return Container();
    },
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
        height: 148,
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
                              image:
                                  state.credit.cast?[index].profilePath != null
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
                        Text(
                          state.credit.cast?[index].name ?? '',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.credit.cast?[index].character ?? '',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                    return InkWell(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                              id: state.recommendationMovie.results[index]?.id,
                            ),
                          ),
                        );
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
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