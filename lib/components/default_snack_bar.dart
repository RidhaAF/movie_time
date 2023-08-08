import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/utilities/constants.dart';

class DefaultSnackBar extends StatelessWidget {
  const DefaultSnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static void show(
    BuildContext context,
    String text, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            color: whiteColor,
            fontWeight: bold,
          ),
        ),
        backgroundColor: backgroundColor ?? primaryColor,
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
