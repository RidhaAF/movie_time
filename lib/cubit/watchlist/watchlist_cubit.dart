import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  GetStorage box = GetStorage();
  List watchlist = [];
  WatchlistCubit() : super(WatchlistInitial());

  void addToWatchlist(String id) {
    watchlist.add(id);
    print('add $watchlist');
    box.write('watchlist', watchlist);
    emit(WatchlistLoaded(watchlist));
  }

  void removeFromWatchlist(String id) {
    watchlist.remove(id);
    print('remove $watchlist');
    box.write('watchlist', watchlist);
    emit(WatchlistLoaded(watchlist));
  }

  getWatchlist() {
    return watchlist = box.read('watchlist') ?? [];
  }

  void clearWatchlist() {
    watchlist.clear();
    print('watchlist cleared');
    box.write('watchlist', null);
    emit(WatchlistLoaded(watchlist));
  }
}
