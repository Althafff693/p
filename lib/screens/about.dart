import 'package:flutter/material.dart';
import '../services/database.dart';
import '../models/user.dart';
import 'currency_converter.dart';
import 'time_converter.dart';
import '../widgets/bottom_nav.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String username = 'Loading...'; // Placeholder saat data belum di-load

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Panggil fungsi untuk mengambil data pengguna
  }

  Future<void> _loadUserData() async {
    try {
      final db = DatabaseService.instance;
      final userMaps = await db.getAll('users'); // Ambil semua data dari tabel users
      
      if (userMaps.isNotEmpty) {
        // Ambil pengguna pertama (misal pengguna yang sedang login)
        final user = User.fromMap(userMaps.first);
        setState(() {
          username = user.username;
        });
      } else {
        setState(() {
          username = 'No user found';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Error loading user';
      });
      print('Error loading user: $e');
    }
  }

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
          // Tampilkan username dari database
          Text(username, style: TextStyle(fontSize: 20)),
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
