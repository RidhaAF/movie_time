import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_time/components/poster_card.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/utilities/env.dart';

class VerticalPoster extends StatelessWidget {
  final String? posterPath;
  final bool isOriginal;
  const VerticalPoster({
    super.key,
    required this.posterPath,
    this.isOriginal = false,
  });

  @override
  Widget build(BuildContext context) {
    String quality = isOriginal ? 'original' : 'w500';

    return CachedNetworkImage(
      imageUrl: '${Env.imageBaseURL}$quality/$posterPath',
      imageBuilder: (context, imageProvider) => PosterCard(
        width: 102,
        height: 154,
        image: imageProvider,
      ),
      placeholder: (context, url) => verticalPosterShimmer(context),
      errorWidget: (context, url, error) => const PosterCard(
        width: 102,
        height: 154,
      ),
      useOldImageOnUrlChange: true,
    );
  }
}
