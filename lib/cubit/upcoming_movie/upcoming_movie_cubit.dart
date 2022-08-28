import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/upcoming_movie_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'upcoming_movie_state.dart';

class UpcomingMovieCubit extends Cubit<UpcomingMovieState> {
  UpcomingMovieCubit() : super(UpcomingMovieInitial()) {
    getUpcomingMovies();
  }

  void getUpcomingMovies() async {
    try {
      emit(UpcomingMovieLoading());
      final data = await MovieService().getUpcomingMovies();
      emit(UpcomingMovieLoaded(data!));
    } catch (e) {
      emit(UpcomingMovieError());
    }
  }
}
