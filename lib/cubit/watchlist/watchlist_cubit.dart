import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/watchlist_model.dart';
import 'package:movie_time/services/watchlist_service.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  List<WatchlistModel> watchlists = [];
  WatchlistCubit() : super(WatchlistInitial()) {
    getWatchlists();
  }

  void getWatchlists() async {
    try {
      emit(WatchlistLoading());
      var response = await WatchlistService().getWatchlists();

      if (response != null) {
        watchlists = response;
        emit(WatchlistLoaded(watchlists));
      } else {
        emit(WatchlistError());
      }
    } on WatchlistError {
      emit(WatchlistError());
    }
  }

  List<WatchlistModel> getWatchlistsData() {
    return watchlists;
  }
}
