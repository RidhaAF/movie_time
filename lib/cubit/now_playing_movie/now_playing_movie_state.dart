part of 'now_playing_movie_cubit.dart';

abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieInitial extends NowPlayingMovieState {}

class NowPlayingMovieLoading extends NowPlayingMovieState {}

class NowPlayingMovieLoaded extends NowPlayingMovieState {
  final NowPlayingMovieModel nowPlayingMovie;
  const NowPlayingMovieLoaded(this.nowPlayingMovie);

  @override
  List<Object> get props => [nowPlayingMovie];
}

class NowPlayingMovieError extends NowPlayingMovieState {}
