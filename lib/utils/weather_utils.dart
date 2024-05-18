String getWeatherIconPath(num code) {
  switch (code) {
    case 1000:
      return 'assets/sunny.svg';
    case 1003:
      return 'assets/partly_cloudy.svg';
    case 1006:
      return 'assets/cloudy.svg';
    case 1009:
      return 'assets/cloudy.svg';
    case 1030:
      return 'assets/cloudy.svg';
    case 1063:
      return 'assets/rainy.svg';
    case 1066:
      return 'assets/snowy.svg';
    case 1069:
      return 'assets/snowy.svg';
    case 1072:
      return 'assets/rainy.svg';
    case 1087:
      return 'assets/thunderstorm.svg';
    case 1114:
      return 'assets/snowy.svg';
    case 1117:
      return 'assets/snowy.svg';
    case 1135:
      return 'assets/snowy.svg';
    case 1147:
      return 'assets/snowy.svg';
    case 1150:
      return 'assets/snowy.svg';
    case 1153:
      return 'assets/snowy.svg';
    case 1168:
      return 'assets/snowy.svg';
    case 1171:
      return 'assets/snowy.svg';
    case 1180:
      return 'assets/rainy.svg';
    case 1183:
      return 'assets/rainy.svg';
    case 1186:
      return 'assets/rainy.svg';
    case 1189:
      return 'assets/rainy.svg';
    case 1192:
      return 'assets/rainy.svg';
    case 1195:
      return 'assets/rainy.svg';
    case 1198:
      return 'assets/rainy.svg';
    case 1201:
      return 'assets/rainy.svg';
    case 1204:
      return 'assets/snowy.svg';
    case 1207:
      return 'assets/snowy.svg';
    case 1210:
      return 'assets/snowy.svg';
    case 1213:
      return 'assets/snowy.svg';
    case 1216:
      return 'assets/snowy.svg';
    case 1219:
      return 'assets/snowy.svg';
    case 1222:
      return 'assets/snowy.svg';
    case 1225:
      return 'assets/snowy.svg';
    case 1237:
      return 'assets/snowy.svg';
    case 1240:
      return 'assets/rainy.svg';
    case 1243:
      return 'assets/rainy.svg';
    case 1246:
      return 'assets/rainy.svg';
    case 1249:
      return 'assets/rainy.svg';
    case 1252:
      return 'assets/rainy.svg';
    case 1255:
      return 'assets/snowy.svg';
    case 1258:
      return 'assets/snowy.svg';
    case 1261:
      return 'assets/snowy.svg';
    case 1264:
      return 'assets/snowy.svg';
    case 1273:
      return 'assets/rainy.svg';
    case 1276:
      return 'assets/thunderstorm.svg';
    case 1279:
      return 'assets/thunderstorm.svg';
    case 1282:
      return 'assets/thunderstorm.svg';
    default:
      return 'assets/partly_cloudy.svg';
  }
}

String getAirQualityString(num AQIIndex) {
  switch (AQIIndex) {
    case 1 || 2 || 3:
      return '$AQIIndex-Low Health Risk';
    case 4 || 5 || 6:
      return '$AQIIndex-Medium Health Risk';
    default:
      return '$AQIIndex-High Health Risk';
  }
}
