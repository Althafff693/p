import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final db = DatabaseService.instance;
      final userMap = await db.getLoggedInUser(); // Ambil data pengguna yang sedang login

      if (userMap != null) {
        final user = User.fromMap(userMap);
        setState(() {
          username = user.username;
        });
      } else {
        setState(() {
          username = 'No user logged in';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Error loading user';
      });
      print('Error loading user: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar dengan opsi untuk mengubah foto profil
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/profile.png') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.indigo,
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Tampilkan username dari database
            Text(
              username,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(height: 32, thickness: 1),
            // List item untuk navigasi ke fitur lainnya
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.indigo),
              title: Text('Currency Converter'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrencyConverterPage()),
                );
              },
            ),
            Divider(thickness: 1),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.indigo),
              title: Text('Time Converter'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeConverterPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
