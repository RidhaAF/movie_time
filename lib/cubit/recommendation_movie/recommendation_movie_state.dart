part of 'recommendation_movie_cubit.dart';

abstract class RecommendationMovieState extends Equatable {
  const RecommendationMovieState();

  @override
  List<Object> get props => [];
}

class RecommendationMovieInitial extends RecommendationMovieState {}

class RecommendationMovieLoading extends RecommendationMovieState {}

class RecommendationMovieLoaded extends RecommendationMovieState {
  final RecommendationMovieModel recommendationMovie;
  const RecommendationMovieLoaded(this.recommendationMovie);

  @override
  List<Object> get props => [recommendationMovie];
}

class RecommendationMovieError extends RecommendationMovieState {}
