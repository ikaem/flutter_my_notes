import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: FutureBuilder(
          // this should not initialize everywhere
          // TODO this is prolly better
          // https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("there was error: ${snapshot.error}");
            }
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "Enter email"),
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: "Enter password"),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print("user: $userCredential");
                        } on FirebaseAuthException catch (e) {
                          final code = e.code;
                          print("e fore firebase auth exception: ${e.code}");

                          switch (code) {
                            case "user-not-found":
                              print("user not found");
                              break;
                            case "wrong-password":
                              print("wrong password");
                              break;
                            default:
                              print("some error: $code");
                          }
                        } catch (e) {
                          if (e.runtimeType == FirebaseAuthException) {
                            // print("e: $}")
                          }
                          print("error happened: $e");
                          print(
                              "error code: ${e.runtimeType}"); //  FirebaseAuthException
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ],
                );
              default:
                return const Text("Loading...");
            }
          }),
    );
  }
}
