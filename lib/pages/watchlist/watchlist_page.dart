import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_time/components/default_404.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/cubit/watchlist/watchlist_cubit.dart';
import 'package:movie_time/models/watchlist_model.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/pages/series/series_detail_page.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';
import 'package:movie_time/utilities/functions.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  GetStorage box = GetStorage();

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _getData();
      setState(() {});
    }
  }

  _getData() {
    context.read<WatchlistCubit>().getWatchlists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Watchlist',
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistInitial) {
              return Container();
            } else if (state is WatchlistLoading) {
              return gridMoviePosterShimmer(context);
            } else if (state is WatchlistLoaded) {
              List<WatchlistModel> watchlists = state.watchlists;

              if (watchlists.isEmpty) {
                return const Default404();
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: watchlists.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    customBorder: cardBorderRadius,
                    onTap: (() {
                      int id = int.parse(watchlists[i].id ?? '0');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            final isMovie =
                                watchlists[i].watchlistType == 'movie';
                            return isMovie
                                ? MovieDetailPage(id: id)
                                : SeriesDetailPage(id: id);
                          },
                        ),
                      ).then((value) {
                        setState(() {
                          context.read<WatchlistCubit>().getWatchlistsData();
                        });
                      });
                    }),
                    child: CachedNetworkImage(
                      imageUrl:
                          '${Env.imageBaseURL}w500/${watchlists[i].posterPath}',
                      imageBuilder: (context, imageProvider) => Container(
                        height: 102,
                        decoration: BoxDecoration(
                          color: getContainerColor(context),
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
                  );
                },
              );
            }
            return const Default404();
          },
        ),
      ),
    );
  }
}
