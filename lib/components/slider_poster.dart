import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_time/components/horizontal_poster.dart';
import 'package:movie_time/components/slider_dot_indicator.dart';
import 'package:movie_time/models/popular_movie_model.dart';
import 'package:movie_time/utilities/constants.dart';

class SliderPoster extends StatefulWidget {
  final List<Result?> popularMovies;
  const SliderPoster({super.key, required this.popularMovies});

  @override
  State<SliderPoster> createState() => _SliderPosterState();
}

class _SliderPosterState extends State<SliderPoster> {
  final CarouselController _carouselController = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 5,
          itemBuilder: (context, index, realIndex) {
            Result? movie = widget.popularMovies[index];
            int? id = movie?.id ?? 0;

            return Container(
              margin: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: InkWell(
                customBorder: cardBorderRadius,
                onTap: (() {
                  context.push('/movie/detail/$id');
                }),
                child: HorizontalPoster(
                  backdropPath: movie?.backdropPath,
                  isOriginal: true,
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
        SliderDotIndicator(
          current: _current,
          carouselController: _carouselController,
        ),
      ],
    );
  }
}
