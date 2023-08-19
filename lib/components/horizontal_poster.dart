import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_time/components/poster_card.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/utilities/env.dart';

class HorizontalPoster extends StatelessWidget {
  final String? backdropPath;
  final bool isOriginal;
  final bool isBorderRadius;
  final bool isColorFilter;
  const HorizontalPoster({
    super.key,
    required this.backdropPath,
    this.isOriginal = false,
    this.isBorderRadius = true,
    this.isColorFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    String quality = isOriginal ? 'original' : 'w500';

    return CachedNetworkImage(
      imageUrl: '${Env.imageBaseURL}$quality/$backdropPath',
      imageBuilder: (context, imageProvider) => PosterCard(
        width: double.infinity,
        height: 200,
        image: imageProvider,
        isBorderRadius: isBorderRadius,
        isColorFilter: isColorFilter,
      ),
      placeholder: (context, url) => horizontalPosterShimmer(
        context,
        isBorderRadius: isBorderRadius,
      ),
      errorWidget: (context, url, error) => PosterCard(
        width: double.infinity,
        height: 200,
        isBorderRadius: isBorderRadius,
        isColorFilter: isColorFilter,
      ),
      useOldImageOnUrlChange: true,
    );
  }
}
