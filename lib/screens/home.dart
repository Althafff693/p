import 'package:flutter/material.dart';
import 'add_note.dart';
import '../services/database.dart';
import '../models/note.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final db = await DatabaseService.instance.database;
    final data = await db.query('notes');
    setState(() {
      notes = data.map((e) => Note.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotePage()),
              ).then((updated) {
                if (updated == true) {
                  _fetchNotes(); // Memperbarui daftar catatan
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.date),
            onTap: () {
              // Tambahkan fitur detail jika diperlukan
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
