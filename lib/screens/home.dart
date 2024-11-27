import 'package:flutter/material.dart';
import 'add_note.dart';
import '../services/database.dart';
import '../models/note.dart';
import '../widgets/bottom_nav.dart';
import 'note_detail.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = []; // Menyimpan daftar note

  @override
  void initState() {
    super.initState();
    _fetchNotes(); // Mengambil data dari database saat halaman dimuat
  }

  /// Fungsi untuk mengambil data catatan dari database
  Future<void> _fetchNotes() async {
    try {
      final db = await DatabaseService.instance.database; // Akses database
      final data = await db.query('notes'); // Query semua data dari tabel notes
      setState(() {
        notes = data.map((e) => Note.fromMap(e)).toList(); // Konversi ke objek Note
      });
    } catch (e) {
      // Penanganan error
      print('Error fetching notes: $e');
    }
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
              // Navigasi ke halaman tambah catatan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotePage()),
              ).then((updated) {
                if (updated == true) {
                  _fetchNotes(); // Perbarui daftar catatan jika ada perubahan
                }
              });
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Text(
                'No notes available. Add one!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.date,
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Navigasi ke halaman detail saat item dipilih
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(note: note),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0), // Navigasi bawah
    );
  }
}
