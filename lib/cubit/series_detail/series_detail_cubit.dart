import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/series_detail_model.dart';
import 'package:movie_time/services/series_service.dart';

part 'series_detail_state.dart';

class SeriesDetailCubit extends Cubit<SeriesDetailState> {
  SeriesDetailCubit() : super(SeriesDetailInitial());

  void getSeriesDetail(int id) async {
    try {
      emit(SeriesDetailLoading());
      final data = await SeriesService().getSeriesDetail(id);
      emit(SeriesDetailLoaded(data!));
    } catch (e) {
      emit(SeriesDetailError());
    }
  }
}
