import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/utilities/constants.dart';

class Default404 extends StatelessWidget {
  final String? image;
  final double? size;
  final String? title;
  const Default404({super.key, this.image, this.size, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image ?? 'assets/images/il_watchlist.png',
            height: size ?? 120,
          ),
          SizedBox(height: defaultMargin),
          Text(
            title ?? 'You don\'t have a watchlist',
            style: GoogleFonts.plusJakartaSans(
              fontSize: headlineFS,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
