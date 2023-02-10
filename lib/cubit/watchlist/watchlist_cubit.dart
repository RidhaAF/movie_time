import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  GetStorage box = GetStorage();
  List watchlist = [];
  WatchlistCubit() : super(WatchlistInitial()) {
    getWatchlist();
  }

  void getWatchlist() {
    try {
      emit(WatchlistLoading());
      watchlist = box.read('watchlist') ?? [];
      if (watchlist.isNotEmpty) {
        emit(WatchlistLoaded(watchlist));
      } else {
        emit(WatchlistError());
      }
    } on Exception {
      emit(WatchlistError());
    }
  }

  void addToWatchlist({required Map<String, dynamic> movie}) {
    watchlist.add(movie);
    box.write('watchlist', watchlist);
    emit(WatchlistLoaded(watchlist));
  }

  void removeFromWatchlist({required Map<String, dynamic> movie}) {
    watchlist.removeWhere((e) => e['id'] == movie['id']);
    box.write('watchlist', watchlist);
    emit(WatchlistLoaded(watchlist));
  }

  getWatchlistData() {
    return watchlist;
  }

  void clearWatchlist() {
    watchlist.clear();
    box.write('watchlist', null);
    emit(WatchlistLoaded(watchlist));
  }
}
