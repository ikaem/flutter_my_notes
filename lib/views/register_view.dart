import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: Text("Register")),
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
                // final userCredential = await FirebaseAuth.instance
                //     .createUserWithEmailAndPassword(
                //         email: email, password: password);
                // // print("user: $userCredential");
                // final user = FirebaseAuth.instance.currentUser;
                // final user = AuthService.firebase().currentUser;
                // await user?.sendEmailVerification();
                // print("this is user: $user");

                await AuthService.firebase()
                    .create(email: email, password: password);
                await AuthService.firebase().sendEmailVerification();
                navigator.pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                    context, "Password requires at least 6 characters");
              } on InvalidEmailUserAuthException {
                await showErrorDialog(context, "Invalid email submitted");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "This email is already in use");
              } on GenericAuthException {
                await showErrorDialog(
                    context, "There was an issue registering your account");
              }

              // on FirebaseAuthException catch (e) {
              //   print("error catch in firebase auth exception: $e");
              //   showErrorDialog(context, "Contact us, please");
              // } catch (e) {
              //   print("error catch all: $e");
              //   showErrorDialog(context, "Contact us, please");
              // }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                // Navigator.of(context).push()
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: Text("Login?"))
        ],
      ),
    );
  }
}
