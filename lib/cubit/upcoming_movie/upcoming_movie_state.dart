part of 'upcoming_movie_cubit.dart';

abstract class UpcomingMovieState extends Equatable {
  const UpcomingMovieState();

  @override
  List<Object> get props => [];
}

class UpcomingMovieInitial extends UpcomingMovieState {}

class UpcomingMovieLoading extends UpcomingMovieState {}

class UpcomingMovieLoaded extends UpcomingMovieState {
  final UpcomingMovieModel upcomingMovie;
  const UpcomingMovieLoaded(this.upcomingMovie);

  @override
  List<Object> get props => [upcomingMovie];
}

class UpcomingMovieError extends UpcomingMovieState {}
