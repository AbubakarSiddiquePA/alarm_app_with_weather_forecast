import 'package:flutter/material.dart';

class EditAlarmScreen extends StatelessWidget {
  final String time;
  final String label;

  const EditAlarmScreen({super.key, required this.time, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Alarm'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 233, 80, 9),
              ),
            ),
            onPressed: () {},
          ),
          const Text(
            'Edit Alarm',
            style: TextStyle(
                // color: Color.fromARGB(255, 233, 80, 9),
                fontSize: 20),
          ),
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 233, 80, 9),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
