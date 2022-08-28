import 'package:flutter/material.dart';
import 'package:movie_time/utilities/constants.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Watchlist',
      ),
      backgroundColor: bgColorLight1,
      body: Center(
        child: Text(
          'Watchlist Page',
          style: body,
        ),
      ),
    );
  }
}
