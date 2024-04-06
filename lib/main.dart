// import 'package:alarm_app_forecast/database/database.dart';
// import 'package:alarm_app_forecast/home/alarm_home.dart';
// import 'package:alarm_app_forecast/notification/notification.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   var locationStatus = await Permission.location.status;
//   if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
//     await Permission.location.request();
//   }
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   Hive.registerAdapter(AlarmAdapter());
//   // Hive.registerAdapter(AlarmDatabaseAdapter());
//   initializeNotifications();
//   await Hive.initFlutter();
//   await Hive.openBox<Alarm>('alarms'); // Open a Hive box for storing alarms

// // Check and request notification permission
//   var notificationStatus = await Permission.notification.status;
//   if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
//     await Permission.notification.request();
//   }
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: Scaffold(
//           bottomNavigationBar: BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                   icon: Icon(
//                       size: 34,
//                       color: Color.fromARGB(255, 233, 80, 9),
//                       Icons.home),
//                   label: "Home"),
//               BottomNavigationBarItem(
//                   icon: Icon(
//                       size: 34,
//                       color: Color.fromARGB(255, 233, 80, 9),
//                       Icons.settings),
//                   label: "Settings")
//             ],
//           ),
//           body: HomePage(),
//         ),
//         );
//   }
// }
import 'package:alarm_app_forecast/database/database.dart';
import 'package:alarm_app_forecast/home/alarm_home.dart';
import 'package:alarm_app_forecast/notification/notification.dart';
import 'package:alarm_app_forecast/weathernew/weather_home/weather_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(AlarmAdapter());
  // Hive.registerAdapter(AlarmDatabaseAdapter());
  initializeNotifications();
  await Hive.initFlutter();
  await Hive.openBox<Alarm>('alarms'); // Open a Hive box for storing alarms

  // Check and request notification permission
  var notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
    await Permission.notification.request();
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    WeatherHome(), // New settings screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
