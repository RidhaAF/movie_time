part of 'series_season_detail_cubit.dart';

sealed class SeriesSeasonDetailState extends Equatable {
  const SeriesSeasonDetailState();

  @override
  List<Object> get props => [];
}

final class SeriesSeasonDetailInitial extends SeriesSeasonDetailState {}

final class SeriesSeasonDetailLoading extends SeriesSeasonDetailState {}

final class SeriesSeasonDetailLoaded extends SeriesSeasonDetailState {
  final SeriesSeasonDetailModel seriesSeasonDetail;
  const SeriesSeasonDetailLoaded(this.seriesSeasonDetail);

  @override
  List<Object> get props => [seriesSeasonDetail];
}

final class SeriesSeasonDetailError extends SeriesSeasonDetailState {}
