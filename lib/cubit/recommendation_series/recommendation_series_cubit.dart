import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/recommendation_series_model.dart';
import 'package:movie_time/services/series_service.dart';

part 'recommendation_series_state.dart';

class RecommendationSeriesCubit extends Cubit<RecommendationSeriesState> {
  RecommendationSeriesModel? recommendationSeries;
  RecommendationSeriesCubit() : super(RecommendationSeriesInitial());

  void getRecommendationSeries(int id) async {
    try {
      emit(RecommendationSeriesLoading());
      recommendationSeries = await SeriesService().getRecommendationSeries(id);
      if (recommendationSeries?.results?.isNotEmpty ?? false) {
        emit(RecommendationSeriesLoaded(recommendationSeries!));
      } else {
        emit(RecommendationSeriesError());
      }
    } on Exception {
      emit(RecommendationSeriesError());
    }
  }
}
