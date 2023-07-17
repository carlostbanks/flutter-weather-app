import 'package:flutter/material.dart';
import 'package:weather_application/weather_api_service.dart';
import 'package:weather_application/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

void main() async {
  await dotenv.load(fileName: 'lib/.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WeatherApiService apiService = WeatherApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(apiService: apiService),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final WeatherApiService apiService;

  const HomeScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<WeatherModel> _weatherData;
  WeatherModel? _weather; // Store the fetched weather data

  @override
  void initState() {
    super.initState();
    _weatherData = _fetchWeatherData();
  }

  Future<WeatherModel> _fetchWeatherData() async {
    final response = await widget.apiService.fetchWeatherData();
    print('API Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final weather = WeatherModel.fromJson(jsonData);
      setState(() {
        _weather = weather; // Store the weather data
      });
      return weather;
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  String getDescription(int cloudCover) {
    if (cloudCover > 75) {
      return 'Cloudy';
    } else {
      return 'Clear skies';
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: FutureBuilder<WeatherModel>(
        future: _fetchWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final weather = snapshot.data!;
            final description = getDescription(weather.cloudCover.toInt());

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather.cityName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Temperature: ${weather.temperature}°C',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Humidity: ${weather.humidity}%',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Description: $description',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
     bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1 && _weather != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForecastDetailScreen(weather: _weather!),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Forecast',
          ),
        ],
      ),
    );
  }
}

class ForecastDetailScreen extends StatelessWidget {
  final WeatherModel weather;

  const ForecastDetailScreen({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forecast Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'City: ${weather.cityName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Temperature: ${weather.temperature}°C',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Humidity: ${weather.humidity}%',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Wind Gust: ${weather.windGust}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'UV Index: ${weather.uvIndex}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Dew Point: ${weather.dewPoint}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Forecast',
          ),
        ],
      ),
    );
  }
}
