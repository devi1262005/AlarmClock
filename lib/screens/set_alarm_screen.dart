import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm.dart';
import '../providers/alarm_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';  // Import the package

class SetAlarmScreen extends StatefulWidget {
  @override
  _SetAlarmScreenState createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  TimeOfDay? _selectedTime;
  String _selectedTone = 'default';
  DateTime? _selectedDate;
  String _alarmName = '';

  void _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveAlarm() {
    if (_selectedTime != null && _selectedDate != null && _alarmName.isNotEmpty) {
      final newAlarm = Alarm(
        time: _selectedTime!,
        tone: _selectedTone,
        date: _selectedDate!,
        name: _alarmName,
      );
      Provider.of<AlarmProvider>(context, listen: false).addAlarm(newAlarm);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Incomplete Form'),
          content: Text('Please fill in all fields.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(FontAwesomeIcons.clock),  // FontAwesome icon for Set Alarm
            SizedBox(width: 10),
            Text('Set Alarm'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlarmNameField(),
            SizedBox(height: 16),
            _buildDateSelector(),
            SizedBox(height: 16),
            _buildTimePicker(),
            SizedBox(height: 16),
            _buildTonePicker(),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveAlarm,
                child: Text('Save Alarm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Alarm Name',
        border: OutlineInputBorder(),
        icon: Icon(FontAwesomeIcons.bell),  // Using FontAwesome icon
      ),
      onChanged: (value) {
        setState(() {
          _alarmName = value;
        });
      },
    );
  }

  Widget _buildDateSelector() {
    return ListTile(
      title: Text(
        _selectedDate != null
            ? 'Date: ${_selectedDate!.toString().split(' ')[0]}'
            : 'Select Date',
      ),
      leading: Icon(FontAwesomeIcons.calendar),  // Using FontAwesome icon
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );

        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    );
  }
  Widget _buildTimePicker() {
    return InkWell(
      onTap: _pickTime,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Time',
          border: OutlineInputBorder(),
          icon: Icon(FontAwesomeIcons.clock),  // Using FontAwesome icon
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            _selectedTime != null
                ? _selectedTime!.format(context)
                : 'Select Time',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  Widget _buildTonePicker() {
    return DropdownButtonFormField<String>(
      value: _selectedTone,
      onChanged: (value) {
        setState(() {
          _selectedTone = value!;
        });
      },
      items: ['default', 'tone1', 'tone2']
          .map((tone) => DropdownMenuItem(
        value: tone,
        child: Text(tone),
      ))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Select Tone',
        border: OutlineInputBorder(),
        icon: Icon(FontAwesomeIcons.music),  // Using FontAwesome icon
      ),
    );
  }
}

