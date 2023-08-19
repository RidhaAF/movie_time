import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/components/cast_profile_photo.dart';
import 'package:movie_time/components/default_snack_bar.dart';
import 'package:movie_time/components/horizontal_poster.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/components/vertical_poster.dart';
import 'package:movie_time/cubit/aggregate_credit/aggregate_credit_cubit.dart';
import 'package:movie_time/cubit/recommendation_series/recommendation_series_cubit.dart';
import 'package:movie_time/cubit/series_detail/series_detail_cubit.dart';
import 'package:movie_time/cubit/series_season_detail/series_season_detail_cubit.dart';
import 'package:movie_time/cubit/watchlist/watchlist_cubit.dart';
import 'package:movie_time/models/aggregate_credit_model.dart';
import 'package:movie_time/models/recommendation_series_model.dart';
import 'package:movie_time/models/series_detail_model.dart';
import 'package:movie_time/models/series_season_detail_model.dart';
import 'package:movie_time/models/watchlist_model.dart';
import 'package:movie_time/services/watchlist_service.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/functions.dart';
import 'package:readmore/readmore.dart';

class SeriesDetailPage extends StatefulWidget {
  final int? id;
  const SeriesDetailPage({Key? key, this.id}) : super(key: key);

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage>
    with TickerProviderStateMixin {
  bool isWatchlist = false;
  var top = 0.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getData();
    _getWatchlist();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _getData();
      setState(() {});
    }
  }

  _getData() {
    context.read<SeriesDetailCubit>().getSeriesDetail(widget.id ?? 0);
    context
        .read<SeriesSeasonDetailCubit>()
        .getSeriesSeasonDetail(widget.id ?? 0, 1);
    context.read<AggregateCreditCubit>().getAggregateCredits(widget.id ?? 0);
    context
        .read<RecommendationSeriesCubit>()
        .getRecommendationSeries(widget.id ?? 0);
  }

  _getWatchlist() {
    List<WatchlistModel> watchlists =
        context.read<WatchlistCubit>().getWatchlistsData();
    for (WatchlistModel item in watchlists) {
      if (item.id == widget.id.toString()) {
        setState(() {
          isWatchlist = true;
        });
      }
    }
  }

  _watchlistService() async {
    final Map response;
    WatchlistModel watchlist = WatchlistModel(
      id: widget.id.toString(),
      watchlistType: 'series',
    );

    if (isWatchlist) {
      response = await WatchlistService().addToWatchlist(watchlist);
    } else {
      response = await WatchlistService().removeFromWatchlist(watchlist);
    }

    if (context.mounted) {
      if (response['success']) {
        context.read<WatchlistCubit>().getWatchlists();
        DefaultSnackBar.show(
          context,
          isWatchlist ? 'Added to Watchlist' : 'Removed from Watchlist',
          backgroundColor: isWatchlist ? Colors.green : primaryColor,
        );
      } else {
        DefaultSnackBar.show(
          context,
          response['message'],
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SeriesDetailModel series = state.seriesDetail;

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
                        context.pop();
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
                          _watchlistService();
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
                            isWatchlist
                                ? Icons.bookmark_outlined
                                : Icons.bookmark_outline_outlined,
                            semanticLabel: isWatchlist
                                ? 'Add to Watchlist'
                                : 'Remove from Watchlist',
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
                            series.name ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        collapseMode: CollapseMode.parallax,
                        background: seriesBackground(series),
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
                              seriesPoster(series),
                              SizedBox(width: defaultMargin),
                              seriesInfo(series),
                            ],
                          ),
                        ),
                        seriesOverview(series),
                        SizedBox(height: defaultMargin),
                        seriesSeason(series),
                        SizedBox(height: defaultMargin),
                        seriesRating(series),
                        SizedBox(height: defaultMargin),
                        seriesCast(),
                        seriesRecommendation(),
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

  Widget seriesBackground(SeriesDetailModel? series) {
    return HorizontalPoster(
      backdropPath: series?.backdropPath,
      isOriginal: true,
      isBorderRadius: false,
      isColorFilter: true,
    );
  }

  Widget seriesPoster(SeriesDetailModel? series) {
    return VerticalPoster(
      posterPath: series?.posterPath,
      isOriginal: true,
    );
  }

  Widget seriesInfo(SeriesDetailModel? series) {
    String totalSeason = totalSeasonsFormattter(series?.numberOfSeasons ?? 0);
    String genre = series?.genres?.map((genre) => genre.name).join(', ') ?? '';

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
          SizedBox(height: defaultMargin / 2),
          Text(
            '${series?.firstAirDate?.toString().substring(0, 4)} • $totalSeason',
            style: GoogleFonts.plusJakartaSans(
              fontSize: footnoteFS,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(height: defaultMargin / 2),
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
                  genre,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: footnoteFS,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget seriesOverview(SeriesDetailModel? series) {
    TextStyle readModeTS = GoogleFonts.plusJakartaSans(
      color: primaryColor,
      fontSize: subheadlineFS,
      fontWeight: semiBold,
    );

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
          SizedBox(height: defaultMargin / 2),
          ReadMoreText(
            series?.overview ?? '',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.justify,
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimCollapsedText: '... read more',
            trimExpandedText: ' show less',
            delimiter: '',
            lessStyle: readModeTS,
            moreStyle: readModeTS,
          ),
        ],
      ),
    );
  }

  Widget seriesSeason(SeriesDetailModel? series) {
    final seasons =
        series?.seasons?.where((season) => season.seasonNumber != 0);
    _tabController = TabController(length: seasons?.length ?? 0, vsync: this);

    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: TabBar(
            tabs: seasons
                    ?.map(
                        (season) => Tab(text: 'Season ${season.seasonNumber}'))
                    .toList() ??
                [],
            controller: _tabController,
            isScrollable: true,
            indicatorColor: primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: isDarkMode(context) ? whiteColor : blackColor,
            labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: title3FS,
              fontWeight: bold,
            ),
            unselectedLabelColor: mutedColor,
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontSize: title3FS,
            ),
            onTap: (value) {
              context
                  .read<SeriesSeasonDetailCubit>()
                  .getSeriesSeasonDetail(series?.id ?? 0, value + 1);
            },
          ),
        ),
        SizedBox(
          height: 192,
          child: TabBarView(
            controller: _tabController,
            children: seasons?.map((season) {
                  String totalEpisode =
                      totalEpisodesFormatter(season.episodeCount ?? 0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: defaultMargin / 2),
                      BlocBuilder<SeriesSeasonDetailCubit,
                          SeriesSeasonDetailState>(
                        builder: (context, state) {
                          if (state is SeriesSeasonDetailInitial) {
                            return Container();
                          } else if (state is SeriesSeasonDetailLoading) {
                            return horizontalEpisodesList();
                          } else if (state is SeriesSeasonDetailLoaded) {
                            final detail = state.seriesSeasonDetail;
                            final episodes = detail.episodes;

                            return Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  left: defaultMargin,
                                  right: defaultMargin / 2,
                                ),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: episodes?.length ?? 0,
                                itemBuilder: (context, i) {
                                  Episode episode = episodes![i];
                                  String seasonEpisode = seasonEpisodeFormatter(
                                      episode.seasonNumber ?? 0,
                                      episode.episodeNumber ?? 0);
                                  String runtime =
                                      runtimeFormatter(episode.runtime ?? 0);

                                  return Container(
                                    width: 280,
                                    height: 128,
                                    margin: EdgeInsets.only(
                                        right: defaultMargin / 2),
                                    decoration: BoxDecoration(
                                      color: isDarkMode(context)
                                          ? darkGreyColor
                                          : white70Color,
                                      borderRadius:
                                          BorderRadius.circular(defaultRadius),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(defaultMargin / 2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$seasonEpisode • ${dateFormatter(episode.airDate ?? DateTime.parse('1970-01-01'))}',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: subheadlineFS,
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                          Text(
                                            episode.name ?? '',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: isDarkMode(context)
                                                  ? secondaryColor
                                                  : greyColor,
                                              fontSize: caption1FS,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            episode.overview ?? '',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: mutedColor,
                                              fontSize: caption1FS,
                                            ),
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                          ),
                                          SizedBox(height: defaultMargin / 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: yellowColor,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                  width: defaultMargin / 4),
                                              Text(
                                                episode.voteAverage
                                                        ?.toStringAsFixed(1) ??
                                                    '0',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: caption1FS,
                                                  fontWeight: bold,
                                                ),
                                              ),
                                              Text(
                                                '/10',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: mutedColor,
                                                  fontSize: caption1FS,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                runtime,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: isDarkMode(context)
                                                      ? secondaryColor
                                                      : greyColor,
                                                  fontSize: caption1FS,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      SizedBox(height: defaultMargin / 2),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: Text(
                          totalEpisode,
                          style: GoogleFonts.plusJakartaSans(
                            color: isDarkMode(context)
                                ? secondaryColor
                                : greyColor,
                            fontSize: caption1FS,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList() ??
                [],
          ),
        ),
      ],
    );
  }

  Widget seriesRating(SeriesDetailModel? series) {
    String voteCount = voteCountFormatter(series?.voteCount ?? 0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.star_rounded,
            color: yellowColor,
          ),
          SizedBox(width: defaultMargin / 4),
          Text(
            series?.voteAverage?.toStringAsFixed(1) ?? '0',
            style: GoogleFonts.plusJakartaSans(
              fontSize: headlineFS,
              fontWeight: bold,
            ),
          ),
          Text(
            '/10 • $voteCount',
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
          margin: EdgeInsets.only(top: defaultMargin / 2),
          height: 152,
          child: BlocBuilder<AggregateCreditCubit, AggregateCreditState>(
            builder: (context, state) {
              if (state is AggregateCreditInitial) {
                return Container();
              } else if (state is AggregateCreditLoading) {
                return castShimmer(context);
              } else if (state is AggregateCreditLoaded) {
                List<Cast>? casts = state.aggregateCredit.cast;

                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: defaultMargin,
                    right: defaultMargin / 2,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: casts?.length,
                  itemBuilder: (context, index) {
                    Cast? cast = casts?[index];

                    return Container(
                      margin: EdgeInsets.only(right: defaultMargin / 2),
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CastProfilePhoto(posterPath: cast?.profilePath),
                          SizedBox(height: defaultMargin / 2),
                          Text(
                            cast?.name ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: caption1FS,
                              fontWeight: bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: defaultMargin / 4),
                          Text(
                            cast?.roles?[0].character ?? '',
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
    return BlocBuilder<RecommendationSeriesCubit, RecommendationSeriesState>(
      builder: (context, state) {
        if (state is RecommendationSeriesInitial) {
          return Container();
        } else if (state is RecommendationSeriesLoading) {
          return moviePosterShimmer(context);
        } else if (state is RecommendationSeriesLoaded) {
          List<Result>? recommendationSeries =
              state.recommendationSeries.results;

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
                    itemCount: recommendationSeries?.length,
                    itemBuilder: (context, index) {
                      Result? series = recommendationSeries?[index];
                      int? id = series?.id ?? 0;

                      return Container(
                        margin: EdgeInsets.only(right: defaultMargin / 2),
                        child: InkWell(
                          onTap: (() {
                            context
                                .push('/series/detail/$id')
                                .then((value) => _getData());
                          }),
                          child: VerticalPoster(posterPath: series?.posterPath),
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
