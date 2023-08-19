import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_time/components/poster_card.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/utilities/env.dart';

class CastProfilePhoto extends StatelessWidget {
  final String? posterPath;
  const CastProfilePhoto({super.key, required this.posterPath});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${Env.imageBaseURL}w500/$posterPath',
      imageBuilder: (context, imageProvider) => PosterCard(
        width: 80,
        height: 80,
        image: imageProvider,
        isBorderRadius: false,
        isShapeCircle: true,
      ),
      placeholder: (context, url) => castProfilePhotoShimmer(context),
      errorWidget: (context, url, error) => const PosterCard(
        width: 80,
        height: 80,
        isBorderRadius: false,
        isShapeCircle: true,
      ),
    );
  }
}
