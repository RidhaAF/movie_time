import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/movie_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInitial()) {
    getPopular();
  }

  void getPopular() async {
    try {
      emit(MovieLoading());
      MovieModel? movie = await MovieService().getPopular();
      emit(MovieLoaded(movie!));
    } catch (e) {
      emit(MovieError());
    }
  }

  void getLatest() async {
    try {
      emit(MovieLoading());
      MovieModel? movie = await MovieService().getLatest();
      emit(MovieLoaded(movie!));
    } catch (e) {
      emit(MovieError());
    }
  }
}
