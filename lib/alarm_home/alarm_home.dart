import 'package:alarm_app_forecast/alarm_home/alarm_edit/alarm_edit_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

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
                      onPressed: () {},
                      icon: const Icon(Icons.add)),
                )
              ],
            ),
            const SizedBox(height: 20),
            _buildAlarmItem(context, "8:48 PM", "Alarm"),
            const SizedBox(height: 10),
            _buildAlarmItem(context, "04:00 AM", "Wake Up"),
          ],
        ),
      ),
    );
  }

  void _editAlarm(BuildContext context, String time, String label) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlarmScreen(time: time, label: label),
      ),
    );
  }

  Widget _buildAlarmItem(BuildContext context, String time, String label) {
    return ListTile(
      title: GestureDetector(
        onTap: () {
          _editAlarm(context, time, label);
        },
        child: Text(
          time,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Text(
        label,
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 20),
      ),
      trailing: const Icon(
        Icons.toggle_on,
        size: 40,
        color: Colors.green,
      ),
    );
  }
}
