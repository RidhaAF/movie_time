import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/now_playing_movie_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'now_playing_movie_state.dart';

class NowPlayingMovieCubit extends Cubit<NowPlayingMovieState> {
  NowPlayingMovieCubit() : super(NowPlayingMovieInitial()) {
    getNowPlayingMovies();
  }

  void getNowPlayingMovies() async {
    try {
      emit(NowPlayingMovieLoading());
      NowPlayingMovieModel? nowPlayingMovie =
          await MovieService().getNowPlayingMovies();
      emit(NowPlayingMovieLoaded(nowPlayingMovie!));
    } catch (e) {
      emit(NowPlayingMovieError());
    }
  }
}
