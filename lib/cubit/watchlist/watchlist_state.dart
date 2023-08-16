part of 'watchlist_cubit.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistModel> watchlists;

  const WatchlistLoaded(this.watchlists);

  @override
  List<Object> get props => [watchlists];
}

class WatchlistError extends WatchlistState {}
