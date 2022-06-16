import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerifEmailView extends StatefulWidget {
  const VerifEmailView({Key? key}) : super(key: key);

  @override
  State<VerifEmailView> createState() => _VerifEmailViewState();
}

class _VerifEmailViewState extends State<VerifEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify your email")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text("We have send you a confirmation email"),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Text("If you haven't received the email, click 'send' to resend it."),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                final navigator = Navigator.of(context);

                print("user: $user");
                await user?.sendEmailVerification();
                navigator.pushNamed(loginRoute);
                // FirebaseAuth.instance.signOut();
              },
              child: Text("Send")),
          TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);

                await FirebaseAuth.instance.signOut();
                navigator.pushNamedAndRemoveUntil(
                    registerRoute, (route) => false);
              },
              child: Text("Restart"))
        ],
      ),
    );
  }
}
