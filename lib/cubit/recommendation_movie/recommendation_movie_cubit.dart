import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/recommendation_movie.dart';
import 'package:movie_time/services/movie_service.dart';

part 'recommendation_movie_state.dart';

class RecommendationMovieCubit extends Cubit<RecommendationMovieState> {
  RecommendationMovieCubit() : super(RecommendationMovieInitial());

  void getRecommendationMovie(int id) async {
    try {
      emit(RecommendationMovieLoading());
      final data = await MovieService().getRecommendationMovies(id);
      emit(RecommendationMovieLoaded(data!));
    } catch (e) {
      emit(RecommendationMovieError());
    }
  }
}
