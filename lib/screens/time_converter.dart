import 'package:flutter/material.dart';

class TimeConverterPage extends StatefulWidget {
  @override
  _TimeConverterPageState createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  final List<String> timeZones = ['WIB', 'WITA', 'WIT', 'GMT', 'EST'];
  String selectedTimeZone = 'WIB';
  String convertedTime = '';

  void _convertTime() {
    final now = DateTime.now();
    switch (selectedTimeZone) {
      case 'WITA':
        convertedTime = now.add(Duration(hours: 1)).toString();
        break;
      case 'WIT':
        convertedTime = now.add(Duration(hours: 2)).toString();
        break;
      case 'GMT':
        convertedTime = now.toUtc().toString();
        break;
      case 'EST':
        convertedTime = now.toUtc().subtract(Duration(hours: 5)).toString();
        break;
      default:
        convertedTime = now.toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Converter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selectedTimeZone,
            items: timeZones
                .map((zone) => DropdownMenuItem(value: zone, child: Text(zone)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedTimeZone = value!;
                _convertTime();
              });
            },
          ),
          SizedBox(height: 16),
          Text(
            convertedTime,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
