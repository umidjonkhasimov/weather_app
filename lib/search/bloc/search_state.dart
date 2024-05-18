part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchStateDataReady extends SearchState {
  final List<SearchCountryResponse> data;

  SearchStateDataReady({required this.data});
}
