import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

GetStorage box = GetStorage();

Widget moviePosterShimmer(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.fromLTRB(
            defaultMargin, defaultMargin, defaultMargin, 12),
        child: Shimmer.fromColors(
          baseColor: AdaptiveTheme.of(context).brightness == Brightness.dark
              ? bgColorDark3
              : Colors.grey.shade300,
          highlightColor:
              AdaptiveTheme.of(context).brightness == Brightness.dark
                  ? greyColor
                  : Colors.grey.shade100,
          child: Container(
            width: 160,
            height: 24,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 154,
        width: double.infinity,
        child: ListView.builder(
          padding: EdgeInsets.only(left: defaultMargin, right: 8),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: Shimmer.fromColors(
                baseColor:
                    AdaptiveTheme.of(context).brightness == Brightness.dark
                        ? bgColorDark3
                        : Colors.grey.shade300,
                highlightColor:
                    AdaptiveTheme.of(context).brightness == Brightness.dark
                        ? greyColor
                        : Colors.grey.shade100,
                child: Container(
                  width: 102,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget gridMoviePosterShimmer(context) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 2 / 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    padding: EdgeInsets.all(defaultMargin),
    itemCount: 15,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: AdaptiveTheme.of(context).brightness == Brightness.dark
            ? bgColorDark3
            : Colors.grey.shade300,
        highlightColor: AdaptiveTheme.of(context).brightness == Brightness.dark
            ? greyColor
            : Colors.grey.shade100,
        child: Container(
          width: 102,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
        ),
      );
    },
  );
}

Widget sliderMoviePosterShimmer(context) {
  return Column(
    children: [
      CarouselSlider.builder(
        itemCount: 5,
        itemBuilder: (context, index, realIndex) {
          return Container(
            margin: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Shimmer.fromColors(
              baseColor: AdaptiveTheme.of(context).brightness == Brightness.dark
                  ? bgColorDark3
                  : Colors.grey.shade300,
              highlightColor:
                  AdaptiveTheme.of(context).brightness == Brightness.dark
                      ? greyColor
                      : Colors.grey.shade100,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          viewportFraction: 0.95,
          autoPlayInterval: const Duration(seconds: 5),
        ),
      ),
      Shimmer.fromColors(
        baseColor: AdaptiveTheme.of(context).brightness == Brightness.dark
            ? bgColorDark3
            : Colors.grey.shade300,
        highlightColor: AdaptiveTheme.of(context).brightness == Brightness.dark
            ? greyColor
            : Colors.grey.shade100,
        child: Container(
          width: 72,
          height: 8,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
        ),
      ),
    ],
  );
}
