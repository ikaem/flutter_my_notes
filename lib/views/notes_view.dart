// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import "dart:developer" as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes"), actions: <Widget>[
        PopupMenuButton<MenuAction>(onSelected: (value) async {
          print(value);
          devtools.log(value.name);
          final navigator = Navigator.of(context);

          switch (value) {
            case MenuAction.logout:
              // TODO: Handle this case.
              final result = await _showLogoutDialog(context);
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
    );
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    // dialog might not return actual value if dialog is dismissed without clicking on options
    final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign out"),
            content: Text("Are you sure you want to sign out?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes"))
            ],
          );
        });

    return result ?? false;
  }
}
