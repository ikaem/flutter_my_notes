import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: "Enter email"),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: "Enter password"),
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
                // final userCredential = await FirebaseAuth.instance
                // .signInWithEmailAndPassword(
                //     email: email, password: password);
                await AuthService.firebase()
                    .logIn(email: email, password: password);

                // final user = FirebaseAuth.instance.currentUser;
                final user = AuthService.firebase().currentUser;

                if (user?.isEmailVerified == false) {
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
              } on UserNotFoundAuthException {
                await showErrorDialog(context, "User not found");
              } on WrongPasswordAuthException {
                await showErrorDialog(context, "Incorrect credentials");
              } on GenericAuthException {
                await showErrorDialog(
                    context, "There was an issue logging you in");
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
              child: const Text("Register?"))
        ],
      ),
    );
  }
}
