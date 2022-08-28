import 'package:flutter/material.dart';
import 'package:movie_time/utilities/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Profile',
      ),
      backgroundColor: bgColorLight1,
      body: Center(
        child: Text(
          'Profile Page',
          style: body,
        ),
      ),
    );
  }
}
