part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final Map searchResults;
  const SearchLoaded(this.searchResults);

  @override
  List<Object> get props => [searchResults];
}

final class SearchError extends SearchState {}
