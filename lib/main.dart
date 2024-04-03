import 'package:alarm_app_forecast/alarm_home/alarm_home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                    size: 34,
                    color: Color.fromARGB(255, 233, 80, 9),
                    Icons.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                    size: 34,
                    color: Color.fromARGB(255, 233, 80, 9),
                    Icons.settings),
                label: "Settings")
          ],
        ),
        body: HomePage(),
      ),
    );
  }
}
