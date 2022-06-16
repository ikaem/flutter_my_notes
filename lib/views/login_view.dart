import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/main.dart';

import '../utilities/show_error_dialog.dart';

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
      appBar: AppBar(title: Text("Login")),
      body: Column(
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
              final navigator = Navigator.of(context);

              try {
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                print("user: $userCredential");

                final user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified == false) {
                  // send user to other page
                  navigator.pushNamedAndRemoveUntil(
                      verifyEmailRoute, (route) => false);
                  return;
                }
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil("/notes", (route) => false);
                // https://stackoverflow.com/questions/69466478/waiting-asynchronously-for-navigator-push-linter-warning-appears-use-build
                // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
                navigator.pushNamedAndRemoveUntil(notesRoute, (route) => false);

                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => HomePage()));

                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil("/notes", (route) => false);
              } on FirebaseAuthException catch (e) {
                final code = e.code;
                print("e fore firebase auth exception: ${e.code}");

                switch (code) {
                  case "user-not-found":
                    print("user not found");
                    showErrorDialog(context, "This user does not exist");
                    break;
                  case "wrong-password":
                    print("wrong password");
                    showErrorDialog(context, "Incorrect credentials");
                    break;
                  default:
                    showErrorDialog(context, "Contact us, please");
                    print("some error: $code");
                }
              } catch (e) {
                if (e.runtimeType == FirebaseAuthException) {
                  // print("e: $}")
                }
                print("error happened: $e");
                print("error code: ${e.runtimeType}"); //  FirebaseAuthException
                showErrorDialog(context, "Contact us, please");
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                // Navigator.of(context).push()
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text("Register?"))
        ],
      ),
    );
  }
}
