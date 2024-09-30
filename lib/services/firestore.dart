import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of notes
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // create : add new note
  Future<void> addNote(String note, String content) {
    return notes.add({
      'note': note,
      'content': content,
      'timestamp': Timestamp.now(),
    });
  }

  // read : get all notes
  Stream<QuerySnapshot> getNotes() {
    final notesStream = notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // update : update note
  Future<void> updateNote(String id, String note, String content) {
    return notes.doc(id).update({
      'note': note,
      'content': content,
      'timestamp': Timestamp.now(),
    });
  }

  // delete : delete note
  Future<void> deleteNote(String id) {
    return notes.doc(id).delete();
  }
}