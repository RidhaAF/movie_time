import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/cubit/movie/movie_cubit.dart';
import 'package:movie_time/models/movie_model.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
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
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: defaultMargin),
            child: BlocBuilder<MovieCubit, MovieState>(
              builder: (context, state) {
                if (state is MovieInitial) {
                  return Container();
                } else if (state is MovieLoading) {
                  return Column(
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
                  );
                } else if (state is MovieLoaded) {
                  return Column(
                    children: [
                      sliderImage(state.movie),
                      latestMovie(state.movie),
                      latestSeries(state.movie),
                      popular(state.movie),
                      upcoming(state.movie),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget sliderImage(MovieModel movie) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 5,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              height: 200,
              decoration: BoxDecoration(
                color: secondaryColor,
                image: DecorationImage(
                  image: NetworkImage(
                    '${Env.imageBaseURL}original/${movie.results[index].backdropPath}',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(defaultRadius),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            viewportFraction: 0.9,
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
  }

  Widget latestMovie(MovieModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
              defaultMargin, defaultMargin, defaultMargin, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Movie',
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
        SizedBox(
          height: 162,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: defaultMargin),
                width: 114,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  image: DecorationImage(
                    image: NetworkImage(
                      '${Env.imageBaseURL}original/${movie.results[index].posterPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultRadius),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget latestSeries(MovieModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
              defaultMargin, defaultMargin, defaultMargin, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Series',
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
        SizedBox(
          height: 162,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: defaultMargin),
                width: 114,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  image: DecorationImage(
                    image: NetworkImage(
                      '${Env.imageBaseURL}original/${movie.results[index].posterPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultRadius),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget popular(MovieModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
              defaultMargin, defaultMargin, defaultMargin, 8),
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
        SizedBox(
          height: 162,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: defaultMargin),
                width: 114,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  image: DecorationImage(
                    image: NetworkImage(
                      '${Env.imageBaseURL}original/${movie.results[index].posterPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultRadius),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget upcoming(MovieModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
              defaultMargin, defaultMargin, defaultMargin, 8),
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
        SizedBox(
          height: 162,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: defaultMargin),
                width: 114,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  image: DecorationImage(
                    image: NetworkImage(
                      '${Env.imageBaseURL}original/${movie.results[index].posterPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultRadius),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
