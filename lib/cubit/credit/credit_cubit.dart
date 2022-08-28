import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/credit_model.dart';
import 'package:movie_time/services/movie_service.dart';

part 'credit_state.dart';

class CreditCubit extends Cubit<CreditState> {
  CreditCubit() : super(CreditInitial());

  void getCredits(int id) async {
    try {
      emit(CreditLoading());
      final data = await MovieService().getCredits(id);
      emit(CreditLoaded(data!));
    } catch (e) {
      emit(CreditError());
    }
  }
}
