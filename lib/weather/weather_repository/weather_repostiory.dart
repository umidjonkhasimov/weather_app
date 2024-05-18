import 'dart:convert';

import 'package:weather_app/models/current_weather/current_weather_with_forecast.dart';
import 'package:weather_app/models/result_model.dart';
import 'package:weather_app/models/search/search_country.dart';

import '../../models/current_weather/current_weather.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'api.weatherapi.com';
const String apiKey = 'c8845742a2da4d5c923122550240205';

abstract class WeatherRepository {
  // Pass US Zipcode, UK Postcode, Canada Postalcode, IP address, Latitude/Longitude (decimal degree) or city name
  Future<ResultModel<CurrentWeather>> getCurrentWeather(String location);

  // Days should be in 1-10 range
  Future<ResultModel<CurrentWeatherWithForecast>> getCurrentWeatherWithForecast(
      String location, int days);

  Future<ResultModel<List<SearchCountryResponse>>> getCountriesByQuery(String query);
}

class WeatherRepositoryImpl implements WeatherRepository {
  @override
  Future<ResultModel<CurrentWeather>> getCurrentWeather(String location) async {
    final Uri url = Uri.https(
      baseUrl,
      '/v1/current.json',
      {'key': apiKey, 'q': location, 'aqi': 'yes'},
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = CurrentWeather.fromJson(json);

      return ResultSuccess(data: data);
    } else {
      return ResultFailure(Exception());
    }
  }

  @override
  Future<ResultModel<CurrentWeatherWithForecast>> getCurrentWeatherWithForecast(
    String location,
    int days,
  ) async {
    final url = Uri.https(
      baseUrl,
      '/v1/forecast.json',
      {
        'key': apiKey,
        'q': location,
        'days': days.toString(),
        'aqi': 'yes',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = CurrentWeatherWithForecast.fromJson(json);
      return ResultSuccess(data: data);
    } else {
      return ResultFailure(Exception());
    }
  }

  @override
  Future<ResultModel<List<SearchCountryResponse>>> getCountriesByQuery(
      String query) async {
    final url = Uri.https(
      baseUrl,
      '/v1/search.json',
      {
        'key': apiKey,
        'q': query,
      },
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;
      final List<SearchCountryResponse> list = List.empty(growable: true);
      for (var element in json) {
        list.add(SearchCountryResponse.fromJson(element));
      }
      return ResultSuccess(data: list);
    } else {
      return ResultFailure(Exception());
    }
  }
}
