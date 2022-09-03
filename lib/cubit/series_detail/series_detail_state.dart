part of 'series_detail_cubit.dart';

abstract class SeriesDetailState extends Equatable {
  const SeriesDetailState();

  @override
  List<Object> get props => [];
}

class SeriesDetailInitial extends SeriesDetailState {}

class SeriesDetailLoading extends SeriesDetailState {}

class SeriesDetailLoaded extends SeriesDetailState {
  final SeriesDetailModel seriesDetail;
  const SeriesDetailLoaded(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}

class SeriesDetailError extends SeriesDetailState {}
