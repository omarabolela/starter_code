import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_exam/note.dart';

class HomeController extends GetxController {
  bool showDescriptions = true;

  String? uid;
  bool loading = true;
  String? error;

  List<Note> documents = [];

  DocumentReference<Map<String, dynamic>>? _docRef;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  int get count => documents.length;

  @override
  void onInit() {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      error = 'Not signed in';
      loading = false;
      update();
      return;
    }
    uid = user.uid;
    _docRef = FirebaseFirestore.instance.collection('notes').doc(uid);

    _sub = _docRef!.snapshots().listen((doc) {
      if (!doc.exists) {
        documents = [];
      } else {
        final bundle = NotesBundle.fromDoc(doc);
        documents = bundle.documents;
      }
      loading = false;
      error = null;
      update();
    }, onError: (e) {
      loading = false;
      error = e.toString();
      update();
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void toggleDescriptions() {
    showDescriptions = !showDescriptions;
    update();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void addNote() {
  }
}
