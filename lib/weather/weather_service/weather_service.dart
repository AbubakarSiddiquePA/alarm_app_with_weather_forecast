import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';

  Future<Map<String, dynamic>> getCurrentWeather(
      double latitude, double longitude) async {
    final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
    final String url = '$apiUrl?lat=$latitude&lon=$longitude&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
