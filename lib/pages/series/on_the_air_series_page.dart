import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_time/cubit/on_the_air_series/on_the_air_series_cubit.dart';
import 'package:movie_time/pages/series/series_detail_page.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';

class OnTheAirSeriesPage extends StatefulWidget {
  const OnTheAirSeriesPage({super.key});

  @override
  State<OnTheAirSeriesPage> createState() => _OnTheAirSeriesPageState();
}

class _OnTheAirSeriesPageState extends State<OnTheAirSeriesPage> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<OnTheAirSeriesCubit>().getOnTheAirSeries();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'On The Air Series',
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: BlocBuilder<OnTheAirSeriesCubit, OnTheAirSeriesState>(
          builder: (context, state) {
            if (state is OnTheAirSeriesInitial) {
              return Container();
            } else if (state is OnTheAirSeriesLoading) {
              return loadingIndicator();
            } else if (state is OnTheAirSeriesLoaded) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: state.onTheAirSeries.results.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeriesDetailPage(
                            id: state.onTheAirSeries.results[index]?.id,
                          ),
                        ),
                      );
                    }),
                    child: Container(
                      // margin: const EdgeInsets.only(right: 8),
                      width: 102,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        image: DecorationImage(
                          image: state.onTheAirSeries.results[index]
                                      ?.posterPath !=
                                  null
                              ? NetworkImage(
                                  '${Env.imageBaseURL}w500/${state.onTheAirSeries.results[index]?.posterPath}',
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
