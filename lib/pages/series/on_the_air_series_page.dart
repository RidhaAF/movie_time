import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_time/cubit/on_the_air_series/on_the_air_series_cubit.dart';
import 'package:movie_time/models/on_the_air_series_model.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';
import 'package:movie_time/utilities/functions.dart';

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
              List<Result?> onTheAirSeries = state.onTheAirSeries.results;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(defaultMargin),
                itemCount: onTheAirSeries.length,
                itemBuilder: (context, index) {
                  Result? series = onTheAirSeries[index];
                  int? id = series?.id ?? 0;

                  return InkWell(
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
