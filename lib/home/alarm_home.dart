import 'package:alarm_app_forecast/add_alarm_screen/add_alarm_screen.dart';
import 'package:alarm_app_forecast/database/database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Home",
                  style: TextStyle(
                      color: Color.fromARGB(255, 233, 80, 9),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                    color: const Color.fromARGB(255, 233, 80, 9),
                    iconSize: 32,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => AddAlarmScreen(
                                    addAlarm: true,
                                  )));
                    },
                    icon: const Icon(Icons.add)),
              )
            ],
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Alarm>>(
              valueListenable: Hive.box<Alarm>('alarms').listenable(),
              builder: (context, box, _) {
                final alarms = box.values.toList().cast<Alarm>();
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => AddAlarmScreen(
                                      addAlarm: false, // Pass the initial label
                                      initialTime: alarm.time,
                                      initialLabel: alarm.label,
                                      alarm: alarm,
                                    )));
                      },
                      title: Text(
                        alarm.label ?? '', // Show the alarm label
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        alarm.time != null
                            ? '${alarm.time!.hour}:${alarm.time!.minute}' // Show the alarm time
                            : '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: alarms.length,
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
