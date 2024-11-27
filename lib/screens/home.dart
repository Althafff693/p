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

  /// Fungsi untuk menghapus catatan berdasarkan ID
  Future<void> _deleteNote(int id) async {
    try {
      final db = await DatabaseService.instance.database;
      await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
      );
      // Setelah berhasil menghapus, perbarui daftar notes
      _fetchNotes();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notes available. Add one!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Icon(
                        Icons.notes,
                        color: Colors.indigo,
                      ),
                    ),
                    title: Text(
                      note.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Tanyakan konfirmasi sebelum menghapus
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete this note?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context); // Menutup dialog tanpa melakukan apa-apa
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  Navigator.pop(context); // Menutup dialog
                                  _deleteNote(note.id!); // Panggil fungsi untuk menghapus catatan
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0), // Navigasi bawah
    );
  }
}
