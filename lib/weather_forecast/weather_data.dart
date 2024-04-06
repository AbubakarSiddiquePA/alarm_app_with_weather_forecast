import 'dart:convert';
import 'package:alarm_app_forecast/weather_forecast/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class WeatherData {
  var client = WeatherData();

  Future<Weather> getData(var name) async {
    var uriCall = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=c48146ea3b6047d89f5150729231805&q=$name,&aqi=no');
    var response = await http.get(uriCall);
    var body = jsonDecode(response.body);
    return Weather.fromJson(body);
  }

// ////////////////////////////////////////////

//   Future<dynamic> getWeatherDataByLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         permission = await Geolocator.requestPermission();
//         if (permission != LocationPermission.whileInUse &&
//             permission != LocationPermission.always) {
//           throw Exception('Location permission denied');
//         }
//       }

//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       double lat = position.latitude;
//       double lon = position.longitude;

//       var uriCall = Uri.parse(
//           'http://api.weatherapi.com/v1/current.json?key=c48146ea3b6047d89f5150729231805&lang=en&q=$lat,$lon');
//       var response = await http.get(uriCall);
//       var body = jsonDecode(response.body);
//       return Weather.fromJson(body);
//     } catch (e) {
//       print('Error getting weather data by location: $e');
//       return null;
//     }
//   }
// }

  Future<Weather> getCurrentLocationWeather() async {
    var locationData = await WeatherData.getCurrentLocation();
    if (locationData != null) {
      return client.getData(locationData['city']);
    } else {
      throw Exception('Error getting current location');
    }
  }

  static Future<Map<String, String>?> getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        return {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'city': placemarks.isNotEmpty ? placemarks.first.locality ?? '' : '',
        };
      } catch (e) {
        print("Error getting location: $e");
        return null;
      }
    } else {
      await Permission.location.request();
      return null;
    }
  }

  Future<dynamic> getWeatherDataByLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          throw Exception('Location permission denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lon = position.longitude;

      var uriCall = Uri.parse(
          'http://api.weatherapi.com/v1/current.json?key=c48146ea3b6047d89f5150729231805&lang=en&q=$lat,$lon');
      var response = await http.get(uriCall);
      var body = jsonDecode(response.body);
      return Weather.fromJson(body);
    } catch (e) {
      print('Error getting weather data by location: $e');
      return null;
    }
  }
}
