class AirQuality {
  num? co;
  num? no2;
  num? o3;
  num? so2;
  num? pm25;
  num? pm10;
  num? usEpaIndex;
  num? gbDefraIndex;

  AirQuality(
      {this.co,
      this.no2,
      this.o3,
      this.so2,
      this.pm25,
      this.pm10,
      this.usEpaIndex,
      this.gbDefraIndex});

  AirQuality.fromJson(Map<String, dynamic> json) {
    co = json['co'];
    no2 = json['no2'];
    o3 = json['o3'];
    so2 = json['so2'];
    pm25 = json['pm2_5'];
    pm10 = json['pm10'];
    usEpaIndex = json['us-epa-index'];
    gbDefraIndex = json['gb-defra-index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['co'] = co;
    data['no2'] = no2;
    data['o3'] = o3;
    data['so2'] = so2;
    data['pm2_5'] = pm25;
    data['pm10'] = pm10;
    data['us-epa-index'] = usEpaIndex;
    data['gb-defra-index'] = gbDefraIndex;
    return data;
  }
}
