import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/screens/edit%20screen/editScreen_controller.dart';
import 'package:map_exam/screens/home%20screen/homeScreen_controller.dart';

class NoteEditorScreen extends StatelessWidget {
  static const String routeName = '/note-editor';
  const NoteEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteEditorController>(
      init: NoteEditorController(),
      builder: (viewmodel) {
        final readOnly = viewmodel.mode.isView;
        return Scaffold(
          appBar: AppBar(
            title: Text('${viewmodel.mode.label} Note'),
            // actions: [
            // enabling edit button in view mode
            // if (viewmodel.mode.isView)
            //   IconButton(
            //     tooltip: 'Edit',
            //     icon: const Icon(Icons.edit),
            //     onPressed: viewmodel.startEditing,
            //   ),
            //   if (!viewmodel.mode.isView)
            //     IconButton(
            //       tooltip: 'Close',
            //       icon: const Icon(Icons.save),
            //       onPressed: viewmodel.saving ? null : viewmodel.save,
            //     ),
            // ],
          ),
          body: viewmodel.initializing
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: viewmodel.titleCtrl,
                        readOnly: readOnly,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: TextField(
                          controller: viewmodel.descCtrl,
                          readOnly: readOnly,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!viewmodel.mode.isView)
                        ElevatedButton.icon(
                          onPressed: viewmodel.saving ? null : viewmodel.save,
                          icon: const Icon(Icons.check),
                          label: Text(viewmodel.mode.isAdd ? 'Add Note' : 'Save Changes'),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
