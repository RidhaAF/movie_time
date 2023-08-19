import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_time/components/default_404.dart';
import 'package:movie_time/components/default_search_bar.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/components/vertical_poster.dart';
import 'package:movie_time/cubit/search/search_cubit.dart';
import 'package:movie_time/pages/movie/movie_detail_page.dart';
import 'package:movie_time/pages/series/series_detail_page.dart';
import 'package:movie_time/utilities/constants.dart';

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
              hintText: 'Search movie, series, cast...',
              onChanged: (value) => _search(value),
              onPressed: () => _clearSearch(),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const Default404(
                    image: 'assets/images/il_search.png',
                    size: 200,
                    title: 'Search your favorite movie,\nseries or cast',
                  );
                } else if (state is SearchLoading) {
                  return gridMoviePosterShimmer(context);
                } else if (state is SearchLoaded) {
                  List searchResults = state.searchResults['results'];

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
                    itemCount: searchResults.length,
                    itemBuilder: (context, i) {
                      Map result = searchResults[i];

                      return InkWell(
                        customBorder: cardBorderRadius,
                        onTap: (() {
                          int id = result['id'];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                final isMovie = result['title'] != null;

                                return isMovie
                                    ? MovieDetailPage(id: id)
                                    : SeriesDetailPage(id: id);
                              },
                            ),
                          );
                        }),
                        child: VerticalPoster(
                          posterPath: result['poster_path'],
                        ),
                      );
                    },
                  );
                }
                return const Default404(
                  title: 'No results found',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
