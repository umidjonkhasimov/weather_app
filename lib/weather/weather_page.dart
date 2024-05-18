import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:weather_app/models/current_weather/current_weather_with_forecast.dart';
import 'package:weather_app/utils/date_time_utils.dart';
import 'package:weather_app/utils/weather_utils.dart';
import 'package:weather_app/weather/bloc/weather_bloc.dart';
import 'package:weather_app/weather/weather_repository/weather_repostiory.dart';

import '../models/current_weather/forecast.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  static MaterialPageRoute<WeatherPage> route() => MaterialPageRoute(
        builder: (context) => const WeatherPage(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(WeatherRepositoryImpl()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  late final DraggableScrollableController _draggableController;
  late final Location _location;

  @override
  void initState() {
    _draggableController = DraggableScrollableController();
    _location = Location();
    _location.changeSettings(accuracy: LocationAccuracy.high);
    super.initState();
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherBloc = context.read<WeatherBloc>();
    weatherBloc
        .add(WeatherEventGetCurrentWeatherWithForecast(location: 'Tashkent', days: 10));
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherStateCurrentWeatherWithForecastDataReady) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/background.jpg',
                  fit: BoxFit.cover,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    Text(
                      '${state.currentWeather.location?.name}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      '${state.currentWeather.current!.tempC?.toInt()}°',
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${state.currentWeather.current!.condition?.text}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      'Feels like: ${state.currentWeather.current!.feelslikeC?.toInt()}°',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                _buildDraggableSheet(
                  _draggableController,
                  state.currentWeather,
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
        },
      ),
    );
  }


}

DraggableScrollableSheet _buildDraggableSheet(
  DraggableScrollableController draggableController,
  CurrentWeatherWithForecast currentWeather,
) {
  return DraggableScrollableSheet(
    snap: true,
    initialChildSize: .4,
    maxChildSize: 1,
    minChildSize: .4,
    controller: draggableController,
    builder: (BuildContext context, ScrollController scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 56,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              HourlyAndDailyForecast(
                dailyForecast: currentWeather.forecast?.forecastday,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildAirQuality(
                      context,
                      currentWeather
                          .forecast?.forecastday?.first.day?.airQuality?.gbDefraIndex,
                    ),
                    _buildSunriseAndSunset(
                      context,
                      currentWeather.forecast?.forecastday?.first.astro?.sunrise,
                      currentWeather.forecast?.forecastday?.first.astro?.sunset,
                    ),
                    _buildUvAndHumidity(
                      context,
                      currentWeather.forecast?.forecastday?.first.day?.uv,
                      currentWeather.forecast?.forecastday?.first.day?.avghumidity,
                    ),
                    _buildWindKphAndFeelsLike(
                      context,
                      currentWeather.current?.windKph,
                      currentWeather.current?.feelslikeC,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 56),
            ],
          ),
        ),
      );
    },
  );
}

class HourlyAndDailyForecast extends StatefulWidget {
  final List<Forecastday>? dailyForecast;

  const HourlyAndDailyForecast({
    super.key,
    required this.dailyForecast,
  });

  @override
  State<HourlyAndDailyForecast> createState() => _HourlyAndDailyForecastState();
}

class _HourlyAndDailyForecastState extends State<HourlyAndDailyForecast>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          splashBorderRadius: BorderRadius.circular(16),
          splashFactory: NoSplash.splashFactory,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          dividerColor: Colors.transparent,
          controller: _tabController,
          tabs: [
            _buildTab(text: 'Hourly', iconData: Icons.hourglass_full_rounded),
            _buildTab(text: 'Daily', iconData: Icons.calendar_view_day_rounded),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 16),
          height: 150,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildHourlyForecast(widget.dailyForecast?.first),
              _buildDailyForecast(widget.dailyForecast),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildHourlyForecast(Forecastday? dailyForecast) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: dailyForecast?.hour?.length,
    itemBuilder: (context, index) {
      final currItem = dailyForecast?.hour?[index];
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SizedBox(
          width: 70,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.all(0),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 8),
                Text(
                  currItem?.time?.convertTo12HourFormat() ?? '',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                SvgPicture.asset(
                  height: 40,
                  getWeatherIconPath(currItem?.condition?.code ?? 0),
                ),
                Text(
                  '${currItem?.tempC?.toInt()}°',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDailyForecast(List<Forecastday>? dailyForecast) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: dailyForecast?.length,
    itemBuilder: (context, index) {
      final currItem = dailyForecast?[index];
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SizedBox(
          width: 70,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.all(0),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 8),
                Text(
                  currItem?.date?.convertToMonthDayFormat() ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                SvgPicture.asset(
                  height: 40,
                  getWeatherIconPath(currItem?.day?.condition?.code ?? 0),
                ),
                Text(
                  '${currItem?.day?.avgtempC?.toInt()}°',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Tab _buildTab({required String text, required IconData iconData}) {
  return Tab(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    ),
  );
}

Widget _buildAirQuality(
  BuildContext context,
  num? airQuality,
) {
  return SizedBox(
    height: 150,
    width: double.infinity,
    child: Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.primary,
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/air_quality.svg',
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AIR QUALITY',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
            Text(
              getAirQualityString(airQuality ?? 1),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
              ),
            ),
            Container(
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Colors.lightBlue,
                    Colors.blue,
                    Colors.greenAccent,
                    Colors.lightGreen,
                    Colors.amberAccent,
                    Colors.orange,
                    Colors.red,
                    Colors.redAccent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  10,
                  (index) {
                    return index + 1 == airQuality
                        ? Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white,
                            ),
                          )
                        : Container();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildSunriseAndSunset(
  BuildContext context,
  String? sunrise,
  String? sunset,
) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.all(4),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/sunrise.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'SUNRISE',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    sunrise ?? '',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: SizedBox(
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.all(4),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/sunset.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'SUNSET',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    sunset ?? '',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildUvAndHumidity(
  BuildContext context,
  num? uv,
  num? humidity,
) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 16,
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/uv_index.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'UV INDEX',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    uv.toString(),
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: SizedBox(
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 16,
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/humidity.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'HUMIDITY',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    '$humidity%',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildWindKphAndFeelsLike(
  BuildContext context,
  num? windKph,
  num? feelsLike,
) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 16,
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/wind.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'WIND',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    '${windKph?.toInt()} km/h',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: SizedBox(
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 16,
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/feels_like.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'FEELS LIKE',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    '${feelsLike?.toInt()} °',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
