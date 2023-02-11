import 'package:flutter/material.dart';
import 'package:movie_time/utilities/constants.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Search',
      ),
      body: Center(
        child: Text(
          'Search Page',
          style: body,
        ),
      ),
    );
  }
}
