import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_time/models/aggregate_credit_model.dart';
import 'package:movie_time/services/series_service.dart';

part 'aggregate_credit_state.dart';

class AggregateCreditCubit extends Cubit<AggregateCreditState> {
  AggregateCreditCubit() : super(AggregateCreditInitial());

  void getAggregateCredits(int id) async {
    try {
      emit(AggregateCreditLoading());
      final data = await SeriesService().getAggregateCredits(id);
      emit(AggregateCreditLoaded(data!));
    } catch (e) {
      emit(AggregateCreditError());
    }
  }
}
