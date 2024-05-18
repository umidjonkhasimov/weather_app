part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class SearchEventSearchCountries extends SearchEvent {
  final String query;

  SearchEventSearchCountries({required this.query});
}
