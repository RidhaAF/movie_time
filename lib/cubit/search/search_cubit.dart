import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/services/search_service.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  Map _searchResults = {};
  SearchCubit() : super(SearchInitial());

  void searchMulti(String query) async {
    try {
      emit(SearchLoading());
      _searchResults = await SearchService().searchMulti(query);
      if (_searchResults['results'].length == 0) {
        emit(SearchError());
        return;
      } else {
        emit(SearchLoaded(_searchResults));
      }
    } catch (e) {
      emit(SearchError());
    }
  }

  clearSearch() {
    _searchResults = {};
    emit(SearchInitial());
  }
}
