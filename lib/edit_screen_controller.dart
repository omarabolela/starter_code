import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/home_screen_controller.dart';
import 'package:map_exam/note.dart';

class NoteEditorController extends GetxController {
  bool initializing = true;
  bool saving = false;
  late NoteScreenMode mode;
  Note? note;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  DocumentReference<Map<String, dynamic>>? _docRef;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final args = Get.arguments;
      if (args is NoteScreenArgs<Note?>) {
        mode = args.mode;
        note = args.payload;
      } else if (args is Map && args['mode'] is NoteScreenMode) {
        mode = args['mode'] as NoteScreenMode;
        note = args['note'] as Note?;
      } else {
        mode = NoteScreenMode.add;
        note = null;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Auth error', 'Not signed in');
        Get.back();
        return;
      }
      _docRef = FirebaseFirestore.instance.collection('notes').doc(user.uid);

      if (mode.isAdd) {
        titleCtrl.text = '';
        descCtrl.text = '';
      } else {
        titleCtrl.text = note?.title ?? '';
        descCtrl.text = note?.description ?? '';
      }
    } finally {
      initializing = false;
      update();
    }
  }

  void startEditing() {
    if (!mode.isView) return;
    mode = NoteScreenMode.edit;
    update();
  }

  Future<void> save() async {
    if (_docRef == null) return;

    final title = titleCtrl.text.trim();
    final desc = descCtrl.text.trim();
    if (title.isEmpty || desc.isEmpty) {
      Get.snackbar('Nothing to save', 'Title or description must not both be empty.');
      return;
    }

    saving = true;
    update();

    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(_docRef!);
        final data = snap.data() ?? <String, dynamic>{};
        final List docs = List.from(data['documents'] ?? []);

        if (mode.isAdd) {
          final newNote = Note(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: title,
            description: desc,
          );
          docs.add(newNote.toMap());
        } else if (mode.isEdit && note != null) {
          final idx = docs.indexWhere((m) => (m['id'] ?? '') == note!.id);
          if (idx != -1) {
            docs[idx] = {
              'id': note!.id,
              'title': title,
              'description': desc,
            };
          }
        }

        tx.set(_docRef!, {'documents': docs}, SetOptions(merge: true));
      });

      Get.back();
    } catch (e) {
      Get.snackbar('Save failed', e.toString());
    } finally {
      saving = false;
      update();
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.onClose();
  }
}
