part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

class WeatherEventGetCurrentWeatherWithForecastByCountry extends WeatherEvent {
  final String location;

  WeatherEventGetCurrentWeatherWithForecastByCountry({required this.location});
}

class WeatherEventGetCurrentWeatherWithForecast extends WeatherEvent {
  final String location;
  final int days;

  WeatherEventGetCurrentWeatherWithForecast({required this.location, required this.days});
}
