import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:movie_time/utilities/constants.dart';

class SliderDotIndicator extends StatelessWidget {
  final int current;
  final CarouselController carouselController;
  const SliderDotIndicator({
    super.key,
    required this.current,
    required this.carouselController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => carouselController.animateToPage(i),
          child: Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: defaultMargin / 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: current == i ? primaryColor : mutedColor,
            ),
          ),
        );
      }),
    );
  }
}
