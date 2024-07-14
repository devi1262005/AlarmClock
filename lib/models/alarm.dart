import 'package:flutter/material.dart';

class Alarm {
  final TimeOfDay time;
  final String tone;
  final DateTime date;
  final String name;
  bool isActive;
  final int id=0;

  Alarm({
    required this.time,
    required this.tone,
    required this.date,
    required this.name,
    this.isActive=true,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      tone: json['tone'],
      date: DateTime.parse(json['date']),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'tone': tone,
      'date': date.toIso8601String(),
      'name': name,
    };
  }
}
