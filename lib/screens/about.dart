import 'package:flutter/material.dart';
import 'currency_converter.dart';
import 'time_converter.dart';
import '../widgets/bottom_nav.dart';


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.png'),
          ),
          SizedBox(height: 16),
          Text('Your Name', style: TextStyle(fontSize: 20)),
          ListTile(
            title: Text('Currency Converter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyConverterPage()),
              );
            },
          ),
          ListTile(
            title: Text('Time Converter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimeConverterPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
