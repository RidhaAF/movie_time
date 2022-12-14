import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/cubit/credit/credit_cubit.dart';
import 'package:movie_time/cubit/recommendation_movie/recommendation_movie_cubit.dart';
import 'package:movie_time/cubit/series_detail/series_detail_cubit.dart';
import 'package:movie_time/models/series_detail_model.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';
import 'package:readmore/readmore.dart';

class SeriesDetailPage extends StatefulWidget {
  final int? id;
  const SeriesDetailPage({Key? key, this.id}) : super(key: key);

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  bool isWatchlist = false;
  var top = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<SeriesDetailCubit>().getSeriesDetail(widget.id ?? 0);
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<SeriesDetailCubit>().getSeriesDetail(widget.id ?? 0);
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
        child: BlocBuilder<SeriesDetailCubit, SeriesDetailState>(
          builder: (context, state) {
            if (state is SeriesDetailInitial) {
              return Container();
            } else if (state is SeriesDetailLoading) {
              return loadingIndicator();
            } else if (state is SeriesDetailLoaded) {
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
                            state.seriesDetail.name ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        collapseMode: CollapseMode.parallax,
                        background: seriesBackground(state.seriesDetail),
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
                              seriesPoster(state.seriesDetail),
                              SizedBox(width: defaultMargin),
                              seriesInfo(state.seriesDetail),
                            ],
                          ),
                        ),
                        seriesOverview(state.seriesDetail),
                        SizedBox(height: defaultMargin),
                        seriesRating(state.seriesDetail),
                        SizedBox(height: defaultMargin),
                        // seriesCast(),
                        // seriesRecommendation(),
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
}

Widget seriesBackground(SeriesDetailModel? series) {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      color: secondaryColor,
      image: DecorationImage(
        colorFilter:
            ColorFilter.mode(blackColor.withOpacity(0.3), BlendMode.darken),
        image: series?.backdropPath != null
            ? NetworkImage(
                '${Env.imageBaseURL}original/${series?.backdropPath}',
              )
            : const AssetImage('assets/images/img_null.png') as ImageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget seriesPoster(SeriesDetailModel? series) {
  return Container(
    height: 154,
    width: 102,
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(defaultRadius),
      image: DecorationImage(
        image: series?.posterPath != null
            ? NetworkImage(
                '${Env.imageBaseURL}original/${series?.posterPath}',
              )
            : const AssetImage('assets/images/img_null.png') as ImageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget seriesInfo(SeriesDetailModel? series) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          series?.name ?? '',
          style: GoogleFonts.plusJakartaSans(
            fontSize: title2FS,
            fontWeight: bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${series?.firstAirDate?.toString().substring(0, 4)}',
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
                series?.genres?.map((genre) => genre.name).join(', ') ?? '',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: footnoteFS,
                  fontWeight: semiBold,
                ),
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 8),
        // BlocBuilder<CreditCubit, CreditState>(
        //   builder: (context, state) {
        //     if (state is CreditLoaded) {
        //       return Row(
        //         children: [
        //           Text(
        //             'Director ',
        //             style: GoogleFonts.plusJakartaSans(
        //               fontSize: caption1FS,
        //             ),
        //           ),
        //           Text(
        //             // find all directors
        //             state.credit.crew
        //                     ?.where((crew) => crew.job == 'Director')
        //                     .map((crew) => crew.name)
        //                     .join(', ') ??
        //                 '',
        //             style: GoogleFonts.plusJakartaSans(
        //               fontSize: footnoteFS,
        //               fontWeight: semiBold,
        //             ),
        //           ),
        //         ],
        //       );
        //     }
        //     return Container();
        //   },
        // ),
      ],
    ),
  );
}

Widget seriesOverview(SeriesDetailModel? series) {
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
          series?.overview ?? '',
          style: GoogleFonts.plusJakartaSans(
            color: greyColor,
            fontSize: calloutFS,
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

Widget seriesRating(SeriesDetailModel? series) {
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
          series?.voteAverage?.toStringAsFixed(1) ?? '',
          style: GoogleFonts.plusJakartaSans(
            fontSize: headlineFS,
            fontWeight: bold,
          ),
        ),
        Text(
          '/10 ??? ${series?.voteCount.toString()}',
          style: GoogleFonts.plusJakartaSans(
            color: mutedColor,
            fontSize: caption1FS,
          ),
        ),
      ],
    ),
  );
}

Widget seriesCast() {
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
                            fontSize: caption1FS,
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
                            fontSize: caption1FS,
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

Widget seriesRecommendation() {
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeriesDetailPage(
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
