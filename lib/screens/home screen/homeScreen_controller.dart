import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:map_exam/models/note.dart';
import 'package:map_exam/screens/edit%20screen/editScreen.dart';

class HomeController extends GetxController {
  bool showDescriptions = true;

  String? uid;
  bool loading = true;
  String? error;

  List<Note> documents = [];

  DocumentReference<Map<String, dynamic>>? _docRef;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  int? editingIndex;
  int get count => documents.length;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        loading = false;
        error = 'Not signed in';
        update();
        return;
      }
      uid = user.uid;
      _docRef = FirebaseFirestore.instance.collection('notes').doc(uid);

      final exists = await _docRef!.get();
      if (!exists.exists) {
        await _docRef!.set({'documents': []});
      }

      _sub = _docRef!.snapshots().listen((doc) {
        final data = doc.data() ?? <String, dynamic>{};
        final List raw = List.from(data['documents'] ?? []);
        documents = raw.map((e) => Note.fromMap(Map<String, dynamic>.from(e))).toList();
        loading = false;
        error = null;
        update();
      }, onError: (e) {
        loading = false;
        error = e.toString();
        update();
      });
    } catch (e) {
      loading = false;
      error = e.toString();
      update();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void toggleDescriptions() {
    showDescriptions = !showDescriptions;
    if (!showDescriptions) editingIndex = null;
    update();
  }

  void toggleEditing(int index) {
    if (!showDescriptions) return;
    editingIndex = (editingIndex == index) ? null : index;
    update();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void addNote() {
    Get.toNamed(
      NoteEditorScreen.routeName,
      arguments: const NoteScreenArgs<Note?>(mode: NoteScreenMode.add, payload: null),
    );
  }

  void viewNote(Note note) {
    Get.toNamed(
      NoteEditorScreen.routeName,
      arguments: NoteScreenArgs<Note?>(mode: NoteScreenMode.view, payload: note),
    );
  }

  void editNote(Note note) {
    Get.toNamed(
      NoteEditorScreen.routeName,
      arguments: NoteScreenArgs<Note?>(mode: NoteScreenMode.edit, payload: note),
    );
  }

  Future<void> deleteNote(Note note) async {
    if (_docRef == null) return;
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(_docRef!);
      final data = snap.data() ?? <String, dynamic>{};
      final List arr = List.from(data['documents'] ?? []);
      final idx = arr.indexWhere((m) => (m['id'] ?? '') == note.id);
      if (idx == -1) return;
      arr.removeAt(idx);
      tx.update(_docRef!, {'documents': arr});
    });
    editingIndex = null;
    update();
  }
}

enum NoteScreenMode { view, edit, add }

extension NoteScreenModeX on NoteScreenMode {
  bool get isView => this == NoteScreenMode.view;
  bool get isEdit => this == NoteScreenMode.edit;
  bool get isAdd => this == NoteScreenMode.add;

  String get label {
    switch (this) {
      case NoteScreenMode.view:
        return 'View';
      case NoteScreenMode.edit:
        return 'Edit';
      case NoteScreenMode.add:
        return 'Add';
    }
  }
}

class NoteScreenArgs<T> {
  final NoteScreenMode mode;
  final T? payload;
  const NoteScreenArgs({required this.mode, this.payload});
}
