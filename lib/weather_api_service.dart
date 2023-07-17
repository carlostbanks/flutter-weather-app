// This is the API GET request that retrieves the response from tomorrow.io
// The response shows the current weather in the Miami area

// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  // If API KEY runs out of requests, go to api.tomorrow.io and create a new API KEY with a new email
  final String _baseUrl = 'https://api.tomorrow.io/v4/weather/forecast?location=miami&apikey=pO2wh32xhuVuUaQwRUX2bzCPGMSoLAGg';
  // final String _apiKey = dotenv.env['API_KEY']!;

  Future<http.Response> fetchWeatherData() async {
    final Uri url = Uri.parse('$_baseUrl');
    return await http.get(url);
  }
}
