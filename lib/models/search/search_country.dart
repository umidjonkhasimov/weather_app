
import 'dart:convert';

class SearchCountryResponse {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;

  SearchCountryResponse({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  // CountrySearchResult countrySearchResultFromJson(String str) => CountrySearchResult.fromJson(json.decode(str));
  //
  // String countrySearchResultToJson(CountrySearchResult data) => json.encode(data.toJson());

  factory SearchCountryResponse.fromJson(Map<String, dynamic> json) => SearchCountryResponse(
    id: json["id"],
    name: json["name"],
    region: json["region"],
    country: json["country"],
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "region": region,
    "country": country,
    "lat": lat,
    "lon": lon,
    "url": url,
  };
}
