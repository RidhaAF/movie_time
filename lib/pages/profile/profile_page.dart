import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/utilities/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GetStorage box = GetStorage();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = box.read('isDarkMode') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Profile',
      ),
      body: Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Container(
          decoration: BoxDecoration(
            color:
                box.read('isDarkMode') ?? false ? bgColorDark3 : bgColorLight2,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          child: ListTile(
            leading: Icon(
              Icons.nights_stay_rounded,
              color: yellowColor,
            ),
            title: Text(
              'Dark Mode',
              style: GoogleFonts.plusJakartaSans(
                fontSize: calloutFS,
              ),
            ),
            trailing: Switch.adaptive(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = !isDarkMode;
                  box.write('isDarkMode', isDarkMode);
                  if (isDarkMode) {
                    AdaptiveTheme.of(context).setDark();
                  } else {
                    AdaptiveTheme.of(context).setLight();
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
