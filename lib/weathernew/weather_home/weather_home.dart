import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({Key? key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late String currentLatitude = '0.0';
  late String currentLongitude = '0.0';
  Map<String, dynamic>? currentWeatherData;
  final String apiKey = 'b662e9abd4114adab5a8d0ae8fc06d5d';
  String currentCity = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        setState(() {
          currentLatitude = position.latitude.toString();
          currentLongitude = position.longitude.toString();
          currentCity =
              placemarks.isNotEmpty ? placemarks.first.locality ?? '' : '';
        });

        await _updateWeather();
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      await Permission.location.request();
    }
  }

  String getWeatherIcon(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return '🌞';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      default:
        return '❓';
    }
  }

  Widget getTemperatureWidget() {
    if (currentWeatherData != null &&
        currentWeatherData!['main'] != null &&
        currentWeatherData!['main']['temp'] != null) {
      double temperatureInKelvin =
          currentWeatherData!['main']['temp'].toDouble();
      double temperatureInCelsius = temperatureInKelvin - 273.15;

      return Text(
        '${temperatureInCelsius.toStringAsFixed(2)}°C',
        style: const TextStyle(
          fontSize: 35,
          color: Colors.black,
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Future<void> _updateWeather() async {
    try {
      if (currentLatitude == null || currentLongitude == null) {
        print('Location not available yet.');
        return;
      }

      const String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
      final String url =
          '$apiUrl?lat=$currentLatitude&lon=$currentLongitude&appid=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        currentWeatherData = json.decode(response.body);
        setState(() {});
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Error getting weather: $e');
    }
  }

  String _getCurrentDay() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  String getHighTemperature() {
    if (currentWeatherData != null &&
        currentWeatherData!['main'] != null &&
        currentWeatherData!['main']['temp_max'] != null) {
      double highTemperatureInKelvin =
          currentWeatherData!['main']['temp_max'].toDouble();
      double highTemperatureInCelsius = highTemperatureInKelvin - 273.15;
      return '${highTemperatureInCelsius.toStringAsFixed(2)}°C';
    } else {
      return '';
    }
  }

  String getLowTemperature() {
    if (currentWeatherData != null &&
        currentWeatherData!['main'] != null &&
        currentWeatherData!['main']['temp_min'] != null) {
      double lowTemperatureInKelvin =
          currentWeatherData!['main']['temp_min'].toDouble();
      double lowTemperatureInCelsius = lowTemperatureInKelvin - 273.15;
      return '${lowTemperatureInCelsius.toStringAsFixed(2)}°C';
    } else {
      return ' ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather Screen',
          style: TextStyle(
              color: const Color.fromARGB(255, 233, 80, 9),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Current Weather',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
                Text(
                  currentCity,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _getCurrentDay(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            if (currentWeatherData != null &&
                currentWeatherData!['weather'] != null &&
                currentWeatherData!['weather'].isNotEmpty)
              Column(
                children: [
                  Text(
                    currentWeatherData!['weather'][0]['description'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    getWeatherIcon(currentWeatherData!['weather'][0]['main']),
                    style: const TextStyle(
                      fontSize: 60,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            getTemperatureWidget(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'High: ${getHighTemperature()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Low: ${getLowTemperature()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
