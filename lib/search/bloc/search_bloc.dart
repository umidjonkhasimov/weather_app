import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/models/result_model.dart';
import 'package:weather_app/models/search/search_country.dart';
import 'package:weather_app/weather/weather_repository/weather_repostiory.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(WeatherRepository weatherRepository) : super(SearchInitial()) {
    on<SearchEventSearchCountries>(
      (event, emit) async {
        final response = await weatherRepository.getCountriesByQuery(event.query);
        if (response is ResultSuccess) {
          final data = (response as ResultSuccess<List<SearchCountryResponse>>).data;
          emit(SearchStateDataReady(data: data));
        } else {}
      },
    );
  }
}
