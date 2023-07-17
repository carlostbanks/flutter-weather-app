// This model instantiates the cityName, temperature, humidity, cloudCover, windGust, UVIndex, and dewPoint variables
// I can then use these variables in the main.dart file

class WeatherModel {
  final String cityName;
  final double temperature;
  final double humidity;
  final int cloudCover;
  final double windGust;
  final int uvIndex;
  final double dewPoint;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.cloudCover,
    required this.windGust,
    required this.uvIndex,
    required this.dewPoint,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final cityName = location['name'] as String;
    final timeline = json['timelines']['minutely'][0];
    final values = timeline['values'];
    final temperature = (values['temperature'] as num).toDouble();
    final humidity = (values['humidity'] as num).toDouble();
    final cloudCover = (values['cloudCover'] as num).toInt();
    final windGust = (values['windGust'] as num).toDouble();
    final uvIndex = (values['uvIndex'] as num).toInt();
    final dewPoint = (values['dewPoint'] as num).toDouble();

    return WeatherModel(
      cityName: cityName,
      temperature: temperature,
      humidity: humidity,
      cloudCover: cloudCover,
      windGust: windGust,
      uvIndex: uvIndex,
      dewPoint: dewPoint,
    );
  }
}
