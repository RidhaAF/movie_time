part of 'popular_movie_cubit.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMovieInitial extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieLoaded extends PopularMovieState {
  final PopularMovieModel popularMovie;
  const PopularMovieLoaded(this.popularMovie);

  @override
  List<Object> get props => [popularMovie];
}

class PopularMovieError extends PopularMovieState {}
