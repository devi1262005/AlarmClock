import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm.dart';
import '../providers/alarm_provider.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;

  const AlarmTile({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${alarm.time.format(context)}'),
      subtitle: Text('Tone: ${alarm.tone}'),
      trailing: Switch(
        value: alarm.isActive,
        onChanged: (value) {
          Provider.of<AlarmProvider>(context, listen: false).toggleAlarm(alarm);
        },
      ),
      onLongPress: () {
        Provider.of<AlarmProvider>(context, listen: false).removeAlarm(alarm);
      },
    );
  }
}
