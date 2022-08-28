part of 'on_the_air_series_cubit.dart';

abstract class OnTheAirSeriesState extends Equatable {
  const OnTheAirSeriesState();

  @override
  List<Object> get props => [];
}

class OnTheAirSeriesInitial extends OnTheAirSeriesState {}

class OnTheAirSeriesLoading extends OnTheAirSeriesState {}

class OnTheAirSeriesLoaded extends OnTheAirSeriesState {
  final OnTheAirSeriesModel onTheAirSeries;
  const OnTheAirSeriesLoaded(this.onTheAirSeries);

  @override
  List<Object> get props => [onTheAirSeries];
}

class OnTheAirSeriesError extends OnTheAirSeriesState {}
