// lib\views\notes\new_note_view.dart

import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({Key? key}) : super(key: key);

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) return existingNote;

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);

    final newNote = await _notesService.createNote(owner: owner);

    return newNote;
  }

  Future<void> _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(id: note.id);
      return;
    }
  }

  Future<void> _saveNoteIfTextNoteEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (_textController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(note: note, text: text);
      return;
    }
  }

  Future<void> _textControllerListener() async {
    final note = _note;
    if (note == null) return;

    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
// TODO test only
// final arguments = ModalRoute.of()

    _textController = TextEditingController();
    // this is singleton anyhow
    _notesService = NotesService();

    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNoteEmpty();
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your note"),
      ),
      body: FutureBuilder(
          future: createNewNote(),
          builder: (context, AsyncSnapshot<DatabaseNote> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data;
                _setupTextControllerListener();

                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration:
                      InputDecoration(hintText: "Start typing your note..."),
                );

              default:
                return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()),
                );
            }
          }),
    );
  }
}
