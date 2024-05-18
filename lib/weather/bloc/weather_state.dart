part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherStateLoading extends WeatherState {}

final class WeatherStateCurrentWeatherDataReady extends WeatherState {
  final CurrentWeather currentWeather;

  WeatherStateCurrentWeatherDataReady({required this.currentWeather});
}

final class WeatherStateCurrentWeatherWithForecastDataReady extends WeatherState {
  final CurrentWeatherWithForecast currentWeather;

  WeatherStateCurrentWeatherWithForecastDataReady({required this.currentWeather});
}
