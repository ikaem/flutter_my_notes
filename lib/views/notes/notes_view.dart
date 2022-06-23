// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import "dart:developer" as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/log_out_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final CloudStorageService _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = CloudStorageService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes"), actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(editNoteRoute);
            },
            icon: Icon(Icons.add)),
        PopupMenuButton<MenuAction>(onSelected: (value) async {
          print(value);
          devtools.log(value.name);
          final navigator = Navigator.of(context);

          switch (value) {
            case MenuAction.logout:
              final result = await showLogoutDialog(context);
              devtools.log("result: $result");

              if (result) {
                await AuthService.firebase().logout();
                navigator.pushNamedAndRemoveUntil(homeRoute, (route) => false);
              }
              break;
            default:
              return;
          }
        }, itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: MenuAction.logout,
              child: Text("Logout"),
            )
          ];
        })
      ]),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerId: userId),
        builder: ((context, AsyncSnapshot<Iterable<CloudNote>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Waiting for all notes");
          }

          if (snapshot.connectionState == ConnectionState.active) {
            // return const Text("Waiting for all notes");

            if (!snapshot.hasData) {
              return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            final data = snapshot.data!;

            return NotesListView(
                notes: data,
                onTap: (note) async {
                  Navigator.of(context)
                      // .pushNamed(editNoteRoute, arguments: note);
                      .pushNamed(editNoteRoute, arguments: note.documentId);
                },
                onDeleteNote: (note) async {
                  _notesService.deleteNote(documentId: note.documentId);
                });
          }

          return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          );
        }),
      ),
    );
  }
}
