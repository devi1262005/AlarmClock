import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'set_alarm_screen.dart';
import '/models/alarm.dart';
import '../providers/alarm_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm Clock'),
      ),
      body: ListView.builder(
        itemCount: alarmProvider.alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarmProvider.alarms[index];
          return ListTile(
            title: Text(alarm.name),
            subtitle: Text('${alarm.date.toString().split(' ')[0]} at ${alarm.time.format(context)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: alarm.isActive,
                  onChanged: (value) {
                    alarmProvider.toggleAlarm(alarm); // Toggle the alarm's active state
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.trashCan),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, alarmProvider, alarm);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SetAlarmScreen()),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, AlarmProvider alarmProvider, Alarm alarm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this alarm?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                alarmProvider.removeAlarm(alarm); // Remove the alarm
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
