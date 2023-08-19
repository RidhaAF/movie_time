import 'package:flutter/material.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/functions.dart';

class PosterCard extends StatelessWidget {
  final double width;
  final double height;
  final ImageProvider<Object> image;
  final bool isBorderRadius;
  final bool isShapeCircle;
  final bool isColorFilter;
  const PosterCard({
    super.key,
    required this.width,
    required this.height,
    this.image = const AssetImage('assets/images/img_null.png'),
    this.isBorderRadius = true,
    this.isShapeCircle = false,
    this.isColorFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: getContainerColor(context),
        shape: isShapeCircle ? BoxShape.circle : BoxShape.rectangle,
        image: DecorationImage(
          colorFilter: isColorFilter
              ? ColorFilter.mode(blackColor.withOpacity(0.3), BlendMode.darken)
              : null,
          image: image,
          fit: BoxFit.cover,
        ),
        borderRadius:
            isBorderRadius ? BorderRadius.circular(defaultRadius) : null,
      ),
    );
  }
}
