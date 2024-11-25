import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WeatherWidget extends StatefulWidget {
  final String initialCity;

  WeatherWidget({required this.initialCity});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late String _city;

  @override
  void initState() {
    super.initState();
    _city = widget.initialCity;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: _city,
          items: ['Jakarta', 'London', 'New York', 'Tokyo', 'Paris'].map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (String? newCity) {
            setState(() {
              _city = newCity!;
            });
          },
        ),
        FutureBuilder(
          future: ApiService().getWeather(_city),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Failed to load weather'));
            }

            final data = snapshot.data as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${data['location']['name']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Temperature: ${data['current']['temp_c']}°C', style: TextStyle(fontSize: 16)),
                Text('Condition: ${data['current']['condition']['text']}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Image.network(
                  'https:${data['current']['condition']['icon']}',
                  width: 64,
                  height: 64,
                ),
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            );
          },
        ),
      ],
    );
  }
}
