import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/series_season_detail_model.dart';
import 'package:movie_time/services/series_service.dart';

part 'series_season_detail_state.dart';

class SeriesSeasonDetailCubit extends Cubit<SeriesSeasonDetailState> {
  SeriesSeasonDetailCubit() : super(SeriesSeasonDetailInitial());

  void getSeriesSeasonDetail(int id, int seasonNumber) async {
    try {
      emit(SeriesSeasonDetailLoading());
      final data =
          await SeriesService().getSeriesSeasonDetail(id, seasonNumber);
      emit(SeriesSeasonDetailLoaded(data!));
    } catch (e) {
      emit(SeriesSeasonDetailError());
    }
  }
}
