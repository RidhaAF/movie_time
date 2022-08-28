import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/popular_movie_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'popular_movie_state.dart';

class PopularMovieCubit extends Cubit<PopularMovieState> {
  PopularMovieCubit() : super(PopularMovieInitial()) {
    getPopular();
  }

  void getPopular() async {
    try {
      emit(PopularMovieLoading());
      PopularMovieModel? popularMovie = await MovieService().getPopular();
      emit(PopularMovieLoaded(popularMovie!));
    } catch (e) {
      emit(PopularMovieError());
    }
  }
}
