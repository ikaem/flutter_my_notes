import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = Future<void> Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView(
      {Key? key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        final note = notes[index];
        final title = note.text;

        final normalizedTile = title.length < 20
            ? title.padRight(20, " ")
            : title.substring(0, 20);

        return ListTile(
          // title: Text(normalizedTile),
          title: Text(
            title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);

              if (shouldDelete == false) return;
              await onDeleteNote(note);
            },
          ),
          onTap: () {
            onTap(note);
          },
        );
      },
      // itemBuilder: ,
    );
  }
}
