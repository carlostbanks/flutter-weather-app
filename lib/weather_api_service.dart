// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  // Go to api.tomorrow.io to get a new API KEY
  final String _baseUrl = 'https://api.tomorrow.io/v4/weather/forecast?location=miami&apikey=pO2wh32xhuVuUaQwRUX2bzCPGMSoLAGg';
  // final String _apiKey = dotenv.env['API_KEY']!;

  Future<http.Response> fetchWeatherData() async {
    final Uri url = Uri.parse('$_baseUrl');
    return await http.get(url);
  }
}
