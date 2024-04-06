import 'package:alarm_app_forecast/database/database.dart';
import 'package:alarm_app_forecast/home/alarm_home.dart';
import 'package:alarm_app_forecast/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddAlarmScreen extends StatefulWidget {
  final bool? addAlarm;
  final String? initialLabel;
  final DateTime? initialTime;
  final Alarm? alarm;

  const AddAlarmScreen({
    required this.addAlarm,
    Key? key,
    this.initialLabel,
    this.initialTime,
    this.alarm,
  }) : super(key: key);

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  late DateTime selectedTime;
  TextEditingController _labelController = TextEditingController();

  @override
  void initState() {
    selectedTime = widget.initialTime ?? DateTime.now();
    _labelController.text = widget.initialLabel ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addAlarm == true ? 'Add Alarm' : 'Edit Alarm'),
        actions: [
          Visibility(
            visible: widget.addAlarm == false,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Alarm'),
                      content: const Text(
                          'Are you sure you want to delete this alarm?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteAlarm();
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
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
                onPressed: () async {
                  if (_labelController.text.isNotEmpty) {
                    final alarmBox = await Hive.openBox<Alarm>('alarms');

                    if (widget.addAlarm == true) {
                      final newAlarm = Alarm(
                        label: _labelController.text,
                        time: selectedTime,
                      );
                      alarmBox.add(newAlarm);
                      scheduleNotification();
                    } else {
                      final existingAlarm = widget.alarm;
                      if (existingAlarm != null) {
                        final existingIndex = alarmBox.values
                            .toList()
                            .indexWhere(
                                (alarm) => alarm.key == existingAlarm.key);
                        if (existingIndex != -1) {
                          existingAlarm.label = _labelController.text;
                          existingAlarm.time = selectedTime;
                          alarmBox.putAt(existingIndex, existingAlarm);
                        }
                      }
                      scheduleNotification();
                    }

                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => const MyApp()));
                  }
                },
              ),
              Text(
                widget.addAlarm == true ? 'Add Alarm' : 'Edit Alarm',
                style: const TextStyle(
                  fontSize: 20,
                ),
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
          const SizedBox(height: 13),
          Card(
            color: const Color.fromARGB(255, 233, 80, 9),
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            child: GestureDetector(
              onTap: () {
                _showAlarmTimePicker(context);
              },
              child: Container(
                width: 300,
                height: 150,
                child: Center(
                  child: selectedTime != null
                      ? Text(
                          " ${DateFormat('hh:mm a').format(selectedTime)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        )
                      : const Text(
                          "Tap to set time",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _labelController,
              decoration: InputDecoration(
                labelText: widget.addAlarm == true
                    ? 'Alarm Label'
                    : _labelController.text,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 233, 80, 9),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteAlarm() async {
    // Get the Hive box
    final Box<Alarm> alarmBox = Hive.box<Alarm>('alarms');

    // Find the index of the existing object in the box
    final int existingIndex = alarmBox.values.toList().indexOf(widget.alarm!);

    // Delete the alarm from the box
    await alarmBox.deleteAt(existingIndex);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomePage()), // Provide the builder for MyHomePage
      (route) => false,
    );
    // Once deleted, you can navigate back to the previous screen or perform any other action
  }

  void _showAlarmTimePicker(BuildContext context) async {
    final pickedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        final now = DateTime.now();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200.0,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ),
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    selectedTime = newTime;
                  });
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        TimeOfDay(
                          hour: selectedTime.hour,
                          minute: selectedTime.minute,
                        ),
                      );
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = DateTime(1, 1, 1, pickedTime.hour, pickedTime.minute);
      });
    }
  }

  void scheduleNotification() {
    print('Scheduled time: ${selectedTime.hour}:${selectedTime.minute}');

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'basic_channel',
          title: '${_labelController.text}',
          body: 'It\'s time for your alarm!',
        ),
        schedule: NotificationCalendar(
          hour: selectedTime.hour,
          minute: selectedTime.minute,
        ));
  }
}
