import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/weather_widget.dart';
import '../widgets/bottom_nav.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  String _city = 'Jakarta';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar & Weather')),
      body: Column(
        children: [
          // Kalender
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _selectedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
          ),
          
          // Pilih kota
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter city',
            ),
            onChanged: (city) {
              setState(() {
                _city = city;
              });
            },
          ),
          
          // Menampilkan cuaca untuk kota dan tanggal yang dipilih
          Expanded(
            child: WeatherWidget(initialCity: _city),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
