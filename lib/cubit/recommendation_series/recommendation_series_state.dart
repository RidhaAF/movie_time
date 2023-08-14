part of 'recommendation_series_cubit.dart';

sealed class RecommendationSeriesState extends Equatable {
  const RecommendationSeriesState();

  @override
  List<Object> get props => [];
}

final class RecommendationSeriesInitial extends RecommendationSeriesState {}

final class RecommendationSeriesLoading extends RecommendationSeriesState {}

final class RecommendationSeriesLoaded extends RecommendationSeriesState {
  final RecommendationSeriesModel recommendationSeries;

  const RecommendationSeriesLoaded(this.recommendationSeries);

  @override
  List<Object> get props => [recommendationSeries];
}

final class RecommendationSeriesError extends RecommendationSeriesState {}
