// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import "dart:developer" as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/log_out_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    // ..open();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes"), actions: <Widget>[
        IconButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(editNoteRoute, arguments: {
              //   "edit": true,
              // });

              Navigator.of(context).pushNamed(editNoteRoute);
            },
            icon: Icon(Icons.add)),
        PopupMenuButton<MenuAction>(onSelected: (value) async {
          print(value);
          devtools.log(value.name);
          final navigator = Navigator.of(context);

          switch (value) {
            case MenuAction.logout:
              // TODO: Handle this case.
              // final result = await _showLogoutDialog(context);
              final result = await showLogoutDialog(context);
              devtools.log("result: $result");

              if (result) {
                // await FirebaseAuth.instance.signOut();
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
              // onTap: () {
              // context error
              //   _showLogoutDialog(context);
              // },
            )
          ];
        })
      ]),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: _notesService.allNotesStream,
              builder: ((context, AsyncSnapshot<List<DatabaseNote>> snapshot) {
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

                  // print("notes: $data");

                  return NotesListView(
                      notes: data,
                      onTap: (note) async {
                        Navigator.of(context)
                            // .pushNamed(editNoteRoute, arguments: note);
                            .pushNamed(editNoteRoute, arguments: note.id);
                      },
                      onDeleteNote: (note) async {
                        _notesService.deleteNote(id: note.id);
                      });

                  // return ListView.builder(
                  //   itemCount: data?.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     final title = data?[index].text ?? "";

                  //     final normalizedTile = title.length < 20
                  //         ? title.padRight(20, " ")
                  //         : title.substring(0, 20);

                  //     return ListTile(
                  //       // title: Text(normalizedTile),
                  //       title: Text(
                  //         title,
                  //         maxLines: 1,
                  //         softWrap: true,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     );
                  //   },
                  //   // itemBuilder: ,
                  // );
                }

                return Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }),
            );
          }

          return Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

// this is not used anymore
  // Future<bool> _showLogoutDialog(BuildContext context) async {
  //   // dialog might not return actual value if dialog is dismissed without clicking on options
  //   final result = await showDialog<bool>(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Sign out"),
  //           content: Text("Are you sure you want to sign out?"),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(false);
  //                 },
  //                 child: Text("No")),
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(true);
  //                 },
  //                 child: Text("Yes"))
  //           ],
  //         );
  //       });

  //   return result ?? false;
  // }
}
