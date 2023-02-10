import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/cubit/watchlist/watchlist_cubit.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';

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
      context.read<WatchlistCubit>().getWatchlist();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Watchlist',
      ),
      backgroundColor: bgColorLight1,
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistInitial) {
              return Container();
            } else if (state is WatchlistLoading) {
              return loadingIndicator();
            } else if (state is WatchlistLoaded) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: state.watchlist.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            id: state.watchlist[index]['id'],
                          ),
                        ),
                      ).then((value) => setState(() {
                            context.read<WatchlistCubit>().getWatchlistData();
                          }));
                    }),
                    child: Container(
                      width: 102,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        image: DecorationImage(
                          image: state.watchlist[index]?['poster_path'] != null
                              ? NetworkImage(
                                  '${Env.imageBaseURL}w500/${state.watchlist[index]?['poster_path']}',
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
            return Center(
              child: Text(
                'Watchlist is empty',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
