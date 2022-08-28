part of 'movie_detail_cubit.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetailModel movieDetail;
  const MovieDetailLoaded(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class MovieDetailError extends MovieDetailState {}
