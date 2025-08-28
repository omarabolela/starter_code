import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (viewmodel) {
        return Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: viewmodel.toggleDescriptions,
                child: Icon(
                  viewmodel.showDescriptions ? Icons.expand_less : Icons.expand,
                ),
              ),
              // const SizedBox(width: 12),
              // FloatingActionButton(
              //   onPressed: viewmodel.addNote,
              //   child: const Icon(
              //     Icons.add,
              //   ),
              // ),
            ],
          ),
          appBar: AppBar(
            title: const Text('My Notes'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: Text(
                    '${viewmodel.count}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Sign out',
                icon: const Icon(Icons.logout),
                onPressed: viewmodel.signOut,
              ),
            ],
          ),
          body: viewmodel.loading
              ? const Center(child: CircularProgressIndicator())
              : (viewmodel.error != null)
                  ? Center(child: Text('Error: ${viewmodel.error}'))
                  : (viewmodel.documents.isEmpty)
                      ? const Center(child: Text('No notes found for this user.'))
                      : ListView.separated(
                          itemCount: viewmodel.documents.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final result = viewmodel.documents[i];
                            final isActive = viewmodel.editingIndex == i;

                            return ListTile(
                              onLongPress: () => viewmodel.toggleEditing(i),
                              title: Text(result.title.isEmpty ? '(no title)' : result.title),
                              subtitle: viewmodel.showDescriptions
                                  ? Text(
                                      result.description,
                                    )
                                  : null,
                              trailing: (isActive)
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            tooltip: 'Edit',
                                            icon: const Icon(Icons.edit, size: 20),
                                            onPressed: () {}),
                                        IconButton(
                                            tooltip: 'Delete',
                                            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                            onPressed: () => viewmodel.deleteNote(result)),
                                      ],
                                    )
                                  : null,
                            );
                          },
                        ),
        );
      },
    );
  }
}
