import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/recommendation_movie_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'recommendation_movie_state.dart';

class RecommendationMovieCubit extends Cubit<RecommendationMovieState> {
  RecommendationMovieModel? recommendationMovie;
  RecommendationMovieCubit() : super(RecommendationMovieInitial());

  void getRecommendationMovie(int id) async {
    try {
      emit(RecommendationMovieLoading());
      recommendationMovie = await MovieService().getRecommendationMovies(id);
      if (recommendationMovie?.results.isNotEmpty ?? false) {
        emit(RecommendationMovieLoaded(recommendationMovie!));
      } else {
        emit(RecommendationMovieError());
      }
    } on Exception {
      emit(RecommendationMovieError());
    }
  }
}
