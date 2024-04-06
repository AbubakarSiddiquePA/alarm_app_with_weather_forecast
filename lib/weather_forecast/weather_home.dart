// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:alarm_app_forecast/weather_forecast/weather_data.dart';
import 'package:alarm_app_forecast/weather_forecast/weather_model.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var dayInfo = DateTime.now();
var dateFormat = DateFormat('EEEE, d MMM, yyy').format(dayInfo);

class WeatherHome extends StatefulWidget {
  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  var client = WeatherData();

  var data;
  String query = '';

  TextEditingController searchContrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentLocationWeather();
  }

  Future<Weather> getCurrentLocationWeather() async {
    var locationData = await WeatherData.getCurrentLocation();
    if (locationData != null) {
      return client.getData(locationData['city']);
    } else {
      throw Exception('Error getting current location');
    }
  }

  void getWeatherData() async {
    var locationData = await WeatherData.getCurrentLocation();
    if (locationData != null) {
      var weatherData = await client.getData(locationData['city']);
      setState(() {
        data = weatherData;
      });
    } else {
      print('Error getting current location');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Weather>(
          future: query.isEmpty
              ? getCurrentLocationWeather()
              : client.getData(query),
          builder: (context, AsyncSnapshot<Weather?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Oops!'),
                content: const Text(
                  'Enter a valid city name',
                  style: TextStyle(color: Colors.red),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WeatherHome(),
                      ));
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Weather weather = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: size.height * 0.85,
                      width: size.width,
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          colors: [Color(0xff955cd1), Color(0xff3fa2fa)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.2, 0.85],
                        ),
                      ),
                      child: Column(
                        children: [
                          AnimSearchBar(
                            textFieldColor: Colors.white38,
                            textFieldIconColor: Colors.white,
                            helpText: "Search City",
                            color: Colors.grey,
                            width: 250,
                            textController: searchContrller,
                            onSuffixTap: () {
                              searchContrller.clear();
                            },
                            onSubmitted: (p0) {
                              setState(() {
                                query = p0;
                              });
                            },
                          ),
                          Text(
                            '${weather.cityname}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 35),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            dateFormat,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Image.network(
                            'https:${weather.icon}',
                            width: size.width * 0.3,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${weather.condition}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${weather.temp}°',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Gust',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${weather.gust} kp/h',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 23),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'pressure',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${weather.pressure} hpa',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 23),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'UV',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${weather.uv}',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 23),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Precipitation',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${weather.pricipe} mm',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 23),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'wind',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${weather.wind} km/h',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 23),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'LastUpdate',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${weather.last_update}',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
