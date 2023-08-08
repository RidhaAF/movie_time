import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/components/default_search_bar.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/cubit/search/search_cubit.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/pages/series/series_detail_page.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/env.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _clearSearch();
  }

  void _search(String query) {
    if (_searchCtrl.text.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        context.read<SearchCubit>().searchMulti(query);
      });
    } else {
      context.read<SearchCubit>().clearSearch();
    }
    setState(() {});
  }

  void _clearSearch() {
    setState(() {
      _searchCtrl.clear();
      context.read<SearchCubit>().clearSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Search',
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(defaultMargin),
            child: DefaultSearchBar(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              hintText: 'Search movies, series, cast...',
              onChanged: (value) => _search(value),
              onPressed: () => _clearSearch(),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/il_search.png',
                          height: 200,
                        ),
                        SizedBox(height: defaultMargin),
                        Text(
                          'Search for movies, series, cast...',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: headlineFS,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is SearchLoading) {
                  return gridMoviePosterShimmer(context);
                } else if (state is SearchLoaded) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    padding: EdgeInsets.all(defaultMargin),
                    itemCount: state.searchResults['results'].length,
                    itemBuilder: (context, index) {
                      List searchResults = state.searchResults['results'];

                      return InkWell(
                        customBorder: cardBorderRadius,
                        onTap: (() {
                          int id = searchResults[index]['id'];
                          print(id);

                          if (searchResults[index]['title'] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(id: id),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeriesDetailPage(id: id),
                              ),
                            );
                          }
                        }),
                        child: Container(
                          width: 102,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            image: DecorationImage(
                              image:
                                  searchResults[index]?['poster_path'] != null
                                      ? NetworkImage(
                                          '${Env.imageBaseURL}w500/${searchResults[index]?['poster_path']}',
                                        )
                                      : const AssetImage(
                                              'assets/images/img_null.png')
                                          as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(defaultRadius),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/il_watchlist.png',
                        height: 120,
                      ),
                      SizedBox(height: defaultMargin),
                      Text(
                        'Keyword not found',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: headlineFS,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
