import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String description;

  const Note({
    this.id = '',
    required this.title,
    required this.description,
  });

  factory Note.fromMap(Map<String, dynamic> m, {String id = ''}) {
    return Note(
      id: id,
      title: (m['title'] ?? '').toString(),
      description: (m['description'] ?? '').toString(),
    );
  }

  factory Note.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data() ?? <String, dynamic>{};
    return Note(
      id: doc.id,
      title: (m['title'] ?? '').toString(),
      description: (m['description'] ?? m['content'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
      };
}

class NotesBundle {
  final String uid;
  final List<Note> documents;

  const NotesBundle({required this.uid, required this.documents});

  factory NotesBundle.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final raw = (data['documents'] as List<dynamic>? ?? []);
    final items = <Note>[];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        items.add(Note.fromMap(item));
      }
    }
    return NotesBundle(uid: doc.id, documents: items);
  }
}
