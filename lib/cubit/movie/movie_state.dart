part of 'movie_cubit.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final MovieModel movie;
  const MovieLoaded(this.movie);

  @override
  List<Object> get props => [movie];
}

class MovieError extends MovieState {}
