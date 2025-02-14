import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/widgets/task_widgets.dart';
import '../data/firestore.dart';

class StreamNote extends StatelessWidget {
  final bool done;
  const StreamNote(this.done, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDatasource().streamNotes(done),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No tasks available"));
        }

        final notesList = FirestoreDatasource().getNotes(snapshot);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: notesList.length,
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Dismissible(
              key: ValueKey(note.id),
              onDismissed: (direction) {
                FirestoreDatasource().deleteNote(note.id);
              },
              child: TaskWidget(note),
            );
          },
        );
      },
    );
  }
}
