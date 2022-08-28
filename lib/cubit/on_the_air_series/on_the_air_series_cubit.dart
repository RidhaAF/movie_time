import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/on_the_air_series_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'on_the_air_series_state.dart';

class OnTheAirSeriesCubit extends Cubit<OnTheAirSeriesState> {
  OnTheAirSeriesCubit() : super(OnTheAirSeriesInitial()) {
    getOnTheAirSeries();
  }

  void getOnTheAirSeries() async {
    try {
      emit(OnTheAirSeriesLoading());
      final data = await MovieService().getOnTheAirSeries();
      emit(OnTheAirSeriesLoaded(data!));
    } catch (e) {
      emit(OnTheAirSeriesError());
    }
  }
}
