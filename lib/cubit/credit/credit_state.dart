part of 'credit_cubit.dart';

abstract class CreditState extends Equatable {
  const CreditState();

  @override
  List<Object> get props => [];
}

class CreditInitial extends CreditState {}

class CreditLoading extends CreditState {}

class CreditLoaded extends CreditState {
  final CreditModel credit;
  const CreditLoaded(this.credit);

  @override
  List<Object> get props => [credit];
}

class CreditError extends CreditState {}
