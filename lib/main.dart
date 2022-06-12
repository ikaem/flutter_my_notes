import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';

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
    home: const HomePage(),
    // home: const RegisterView(),
    // home: const LoginView()
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: FutureBuilder(
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

                // if (currentUser?.emailVerified != false) {
                if (isEmailVerified) {
                  return Text("Done");
                }

                return Text("Not email verified");

              default:
                return Text("Loading...");
            }
          }),
    );
  }
}
