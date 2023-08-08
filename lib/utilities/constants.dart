import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 16;
double defaultRadius = 8;

Color primaryColor = Colors.red.shade900;
Color secondaryColor = Colors.grey.shade200;
Color mutedColor = Colors.grey;
Color greyColor = Colors.grey.shade800;
Color darkColor = const Color(0xFF090A0A);
Color darkGreyColor = const Color(0xFF1D1D1D);
Color blackColor = Colors.black;
Color whiteColor = Colors.white;
Color yellowColor = Colors.yellow.shade700;
Color bgColorDark1 = const Color(0xFF090A0A);
Color bgColorDark2 = Colors.black;
Color bgColorDark3 = const Color(0xFF1D1D1D);
Color bgColorLight1 = const Color(0xFFF5F5F5);
Color bgColorLight2 = Colors.white;

double largeTitleFS = 34;
double title1FS = 28;
double title2FS = 22;
double title3FS = 20;
double headlineFS = 17;
double bodyFS = 17;
double calloutFS = 16;
double subheadlineFS = 15;
double footnoteFS = 13;
double caption1FS = 12;
double caption2FS = 11;

FontWeight thin = FontWeight.w100;
FontWeight extraLight = FontWeight.w200;
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

// 34
TextStyle largeTitle = GoogleFonts.plusJakartaSans(
  fontSize: largeTitleFS,
);

// 28
TextStyle title1 = GoogleFonts.plusJakartaSans(
  fontSize: title1FS,
);

// 22
TextStyle title2 = GoogleFonts.plusJakartaSans(
  fontSize: title2FS,
);

// 20
TextStyle title3 = GoogleFonts.plusJakartaSans(
  fontSize: title3FS,
);

// 17
TextStyle headline = GoogleFonts.plusJakartaSans(
  color: whiteColor,
  fontSize: headlineFS,
  fontWeight: semiBold,
);

// 17
TextStyle body = GoogleFonts.plusJakartaSans(
  fontSize: bodyFS,
);

// 16
TextStyle callout = GoogleFonts.plusJakartaSans(
  fontSize: calloutFS,
);

// 15
TextStyle subheadline = GoogleFonts.plusJakartaSans(
  fontSize: subheadlineFS,
);

// 13
TextStyle footnote = GoogleFonts.plusJakartaSans(
  fontSize: footnoteFS,
);

// 12
TextStyle caption1 = GoogleFonts.plusJakartaSans(
  fontSize: caption1FS,
);

// 11
TextStyle caption2 = GoogleFonts.plusJakartaSans(
  fontSize: caption2FS,
);

// text style per color
TextStyle primaryTextStyle = GoogleFonts.plusJakartaSans(
  color: primaryColor,
);

TextStyle secondaryTextStyle = GoogleFonts.plusJakartaSans(
  color: secondaryColor,
);

TextStyle mutedTextStyle = GoogleFonts.plusJakartaSans(
  color: mutedColor,
);

TextStyle whiteTextStyle = GoogleFonts.plusJakartaSans(
  color: whiteColor,
);

TextStyle darkGreyTextStyle = GoogleFonts.plusJakartaSans(
  color: darkGreyColor,
);

AppBar appBar({String? title, TextStyle? style}) {
  return AppBar(
    title: Text(
      title ?? '',
      style: style ?? headline,
    ),
    backgroundColor: primaryColor,
    centerTitle: true,
    elevation: 0,
  );
}

Widget loadingIndicator() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: primaryColor,
        ),
        SizedBox(height: defaultMargin),
        Text(
          'Loading',
          style: GoogleFonts.plusJakartaSans(
            fontSize: title3FS,
            fontWeight: semiBold,
          ),
        ),
      ],
    ),
  );
}

ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  padding: EdgeInsets.zero,
  backgroundColor: primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(defaultRadius),
  ),
);

ButtonStyle darkGreyButtonStyle = ElevatedButton.styleFrom(
  padding: EdgeInsets.zero,
  backgroundColor: darkGreyColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(defaultRadius),
  ),
);

Border primaryBorder = Border.all(
  width: 1,
  color: primaryColor,
);

BoxShadow primaryBoxShadow = BoxShadow(
  color: blackColor.withOpacity(0.10),
  spreadRadius: 0,
  blurRadius: 16,
  offset: const Offset(0, 0), // changes position of shadow
);

RoundedRectangleBorder cardBorderRadius = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(defaultRadius),
  ),
);
