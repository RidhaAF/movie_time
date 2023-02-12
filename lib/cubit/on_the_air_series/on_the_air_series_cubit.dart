import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/on_the_air_series_model.dart';
import 'package:movie_time/services/series_service.dart';

part 'on_the_air_series_state.dart';

class OnTheAirSeriesCubit extends Cubit<OnTheAirSeriesState> {
  OnTheAirSeriesCubit() : super(OnTheAirSeriesInitial()) {
    getOnTheAirSeries();
  }

  void getOnTheAirSeries() async {
    try {
      emit(OnTheAirSeriesLoading());
      OnTheAirSeriesModel? series = await SeriesService().getOnTheAirSeries();
      emit(OnTheAirSeriesLoaded(series!));
    } catch (e) {
      emit(OnTheAirSeriesError());
    }
  }
}
