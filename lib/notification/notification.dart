import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Future<void> initializeNotifications() async {
  AwesomeNotifications().initialize('resource://drawable/icon_notification', [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic notifications',
      defaultColor: Color(0xFF9D50DD),
      ledColor: Colors.white,
    ),
  ]);
}
