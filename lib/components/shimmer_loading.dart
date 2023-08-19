import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/functions.dart';
import 'package:shimmer/shimmer.dart';

Widget moviePosterShimmer(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                defaultMargin, defaultMargin, defaultMargin, 12),
            child: Shimmer.fromColors(
              baseColor: getContainerColor(context),
              highlightColor:
                  isDarkMode(context) ? greyColor : Colors.grey.shade100,
              child: Container(
                width: 160,
                height: 24,
                decoration: BoxDecoration(
                  color: getContainerColor(context),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                defaultMargin, defaultMargin, defaultMargin, 12),
            child: Shimmer.fromColors(
              baseColor: getContainerColor(context),
              highlightColor:
                  isDarkMode(context) ? greyColor : Colors.grey.shade100,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: getContainerColor(context),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
              ),
            ),
          ),
        ],
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
              margin: EdgeInsets.only(right: defaultMargin / 2),
              child: Shimmer.fromColors(
                baseColor: getContainerColor(context),
                highlightColor:
                    isDarkMode(context) ? greyColor : Colors.grey.shade100,
                child: Container(
                  width: 102,
                  decoration: BoxDecoration(
                    color: getContainerColor(context),
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
        baseColor: getContainerColor(context),
        highlightColor: isDarkMode(context) ? greyColor : Colors.grey.shade100,
        child: Container(
          width: 102,
          decoration: BoxDecoration(
            color: getContainerColor(context),
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
              baseColor: getContainerColor(context),
              highlightColor:
                  isDarkMode(context) ? greyColor : Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: getContainerColor(context),
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
        baseColor: getContainerColor(context),
        highlightColor: isDarkMode(context) ? greyColor : Colors.grey.shade100,
        child: Container(
          width: 72,
          height: 8,
          decoration: BoxDecoration(
            color: getContainerColor(context),
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
        ),
      ),
    ],
  );
}

Widget horizontalEpisodesList() {
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.only(left: defaultMargin, right: 8),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: getContainerColor(context),
          highlightColor:
              isDarkMode(context) ? greyColor : Colors.grey.shade100,
          child: Container(
            width: 280,
            height: 128,
            margin: EdgeInsets.only(right: defaultMargin / 2),
            decoration: BoxDecoration(
              color: isDarkMode(context) ? darkGreyColor : white70Color,
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
          ),
        );
      },
    ),
  );
}

Widget verticalPosterShimmer(context) {
  return Shimmer.fromColors(
    baseColor: getContainerColor(context),
    highlightColor: isDarkMode(context) ? greyColor : Colors.grey.shade100,
    child: Container(
      width: 102,
      height: 154,
      decoration: BoxDecoration(
        color: getContainerColor(context),
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
    ),
  );
}

Widget horizontalPosterShimmer(context, {bool isBorderRadius = true}) {
  return Shimmer.fromColors(
    baseColor: getContainerColor(context),
    highlightColor: isDarkMode(context) ? greyColor : Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: getContainerColor(context),
        borderRadius:
            isBorderRadius ? BorderRadius.circular(defaultRadius) : null,
      ),
    ),
  );
}

Widget creditShimmer(context) {
  return Shimmer.fromColors(
    baseColor: getContainerColor(context),
    highlightColor: isDarkMode(context) ? greyColor : Colors.grey.shade100,
    child: Row(
      children: [
        Container(
          width: 56,
          height: 16,
          decoration: BoxDecoration(
            color: getContainerColor(context),
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
        ),
        SizedBox(width: defaultMargin / 2),
        Expanded(
          child: lineContainer(context),
        ),
      ],
    ),
  );
}

Widget castShimmer(context) {
  return ListView.builder(
    padding: EdgeInsets.only(left: defaultMargin, right: 8),
    scrollDirection: Axis.horizontal,
    itemCount: 10,
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(right: defaultMargin / 2),
        width: 80,
        child: Shimmer.fromColors(
          baseColor: getContainerColor(context),
          highlightColor:
              isDarkMode(context) ? greyColor : Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: defaultMargin / 2),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: getContainerColor(context),
                  shape: BoxShape.circle,
                ),
              ),
              lineContainer(context),
              SizedBox(height: defaultMargin / 4),
              lineContainer(context),
              SizedBox(height: defaultMargin / 4),
              lineContainer(context),
            ],
          ),
        ),
      );
    },
  );
}

Widget castProfilePhotoShimmer(context) {
  return Shimmer.fromColors(
    baseColor: getContainerColor(context),
    highlightColor: isDarkMode(context) ? greyColor : Colors.grey.shade100,
    child: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: getContainerColor(context),
        shape: BoxShape.circle,
      ),
    ),
  );
}

Widget lineContainer(context) {
  return Container(
    width: double.infinity,
    height: 16,
    decoration: BoxDecoration(
      color: getContainerColor(context),
      borderRadius: BorderRadius.circular(defaultRadius),
    ),
  );
}
