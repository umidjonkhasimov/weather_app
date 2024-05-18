import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:weather_app/models/current_weather/current_weather.dart';
import 'package:weather_app/models/result_model.dart';
import 'package:weather_app/weather/weather_repository/weather_repostiory.dart';

import '../../models/current_weather/current_weather_with_forecast.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(WeatherRepository repository) : super(WeatherStateLoading()) {
    on<WeatherEventGetCurrentWeatherWithForecastByCountry>(
      (event, emit) async {
        emit(WeatherStateLoading());
        final response =
            await repository.getCurrentWeatherWithForecast(event.location, 10);

        if (response is ResultSuccess) {
          final currentWeather = (response as ResultSuccess<CurrentWeatherWithForecast>).data;
          emit(WeatherStateCurrentWeatherWithForecastDataReady(currentWeather: currentWeather));
        } else if (response is ResultFailure) {}
      },
    );

    on<WeatherEventGetCurrentWeatherWithForecast>(
      (event, emit) async {
        emit(WeatherStateLoading());
        final locationData = await _getLocation();
        final response = await repository.getCurrentWeatherWithForecast(
            '${locationData.latitude}, ${locationData.longitude}', event.days);

        if (response is ResultSuccess) {
          final currentWeather =
              (response as ResultSuccess<CurrentWeatherWithForecast>).data;
          emit(WeatherStateCurrentWeatherWithForecastDataReady(
              currentWeather: currentWeather));
        } else if (response is ResultFailure) {}
      },
    );
  }

  Future<LocationData> _getLocation() async {
    final location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      await location.requestService();
    }
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.deniedForever) {
      await location.requestPermission();
    }
    var locationData = await location.getLocation();
    return locationData;
  }
}
