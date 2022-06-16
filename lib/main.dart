import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp());
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // home: const HomePage(),
    // home: const LoginView()
    // home: const HomePage(),
    // home: const RegisterView(),
    routes: {
      homeRoute: (context) => HomePage(),
      loginRoute: (context) => LoginView(),
      registerRoute: (context) => RegisterView(),
      notesRoute: (context) => NotesView(),
      verifyEmailRoute: (context) => VerifEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("There was error with connecting to Firebase");
          }

          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // gettomg current user
              final auth = FirebaseAuth.instance;
              final currentUser = auth.currentUser;
              final isEmailVerified = currentUser?.emailVerified ?? false;

              print("this is current user: ${currentUser}");

              // FirebaseAuth.instance.signOut();
              if (currentUser == null) return LoginView();
              if (!isEmailVerified) {
                return VerifEmailView();
              }
              return NotesView();

            // return Text("Not email verified");

            default:
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator.adaptive()));
          }
        });
  }
}
