// providers/alarm_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/alarm.dart';
import '../screens/ripple_screen.dart';

class AlarmProvider with ChangeNotifier {
  List<Alarm> _alarms = [];

  List<Alarm> get alarms => _alarms;

  AlarmProvider() {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsString = prefs.getString('alarms') ?? '[]';
    final alarmsJson = json.decode(alarmsString) as List;
    _alarms = alarmsJson.map((json) => Alarm.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = json.encode(_alarms.map((alarm) => alarm.toJson()).toList());
    await prefs.setString('alarms', alarmsJson);
  }

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    _saveAlarms();
    scheduleAlarm(alarm);
    notifyListeners();
  }

  void removeAlarm(Alarm alarm) {
    _alarms.remove(alarm);
    _saveAlarms();
    cancelAlarm(alarm);
    notifyListeners();
  }

  void toggleAlarm(Alarm alarm) {
    final index = _alarms.indexOf(alarm);
    _alarms[index].isActive = !_alarms[index].isActive;
    _saveAlarms();
    if (_alarms[index].isActive) {
      scheduleAlarm(_alarms[index]);
    } else {
      cancelAlarm(_alarms[index]);
    }
    notifyListeners();
  }

  void scheduleAlarm(Alarm alarm) {
    final now = DateTime.now();
    var scheduleTime = DateTime(
      alarm.date.year,
      alarm.date.month,
      alarm.date.day,
      alarm.time.hour,
      alarm.time.minute,
    );
    if (scheduleTime.isBefore(now)) {
      scheduleTime = scheduleTime.add(Duration(days: 1));
    }
    print('Scheduling alarm at $scheduleTime');
    AndroidAlarmManager.oneShotAt(
      scheduleTime,
      alarm.hashCode,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  void cancelAlarm(Alarm alarm) {
    AndroidAlarmManager.cancel(alarm.hashCode);
  }

  static void alarmCallback(int id) async {
    print('Alarm callback triggered with id: $id');
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      'Alarm',
      'Time for your alarm!',
      platformChannelSpecifics,
      payload: jsonEncode({'id': id}),
    );
  }

  static Future<void> rescheduleAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsString = prefs.getString('alarms') ?? '[]';
    final alarmsJson = json.decode(alarmsString) as List;
    final alarms = alarmsJson.map((json) => Alarm.fromJson(json)).toList();

    for (var alarm in alarms) {
      if (alarm.isActive) {
        final now = DateTime.now();
        var scheduleTime = DateTime(
          alarm.date.year,
          alarm.date.month,
          alarm.date.day,
          alarm.time.hour,
          alarm.time.minute,
        );
        if (scheduleTime.isBefore(now)) {
          scheduleTime = scheduleTime.add(Duration(days: 1));
        }
        print('Rescheduling alarm at $scheduleTime');
        AndroidAlarmManager.oneShotAt(
          scheduleTime,
          alarm.hashCode,
          alarmCallback,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
        );
      }
    }
  }
}
