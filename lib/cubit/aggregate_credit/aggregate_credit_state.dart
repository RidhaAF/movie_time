part of 'aggregate_credit_cubit.dart';

sealed class AggregateCreditState extends Equatable {
  const AggregateCreditState();

  @override
  List<Object> get props => [];
}

final class AggregateCreditInitial extends AggregateCreditState {}

final class AggregateCreditLoading extends AggregateCreditState {}

final class AggregateCreditLoaded extends AggregateCreditState {
  final AggregateCreditModel aggregateCredit;

  const AggregateCreditLoaded(this.aggregateCredit);

  @override
  List<Object> get props => [aggregateCredit];
}

final class AggregateCreditError extends AggregateCreditState {}
