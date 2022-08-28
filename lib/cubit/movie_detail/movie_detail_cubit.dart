import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/movie_detail_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit() : super(MovieDetailInitial());

  void getMovieDetail(int id) async {
    try {
      emit(MovieDetailLoading());
      final data = await MovieService().getMovieDetail(id);
      emit(MovieDetailLoaded(data!));
    } catch (e) {
      emit(MovieDetailError());
    }
  }
}
