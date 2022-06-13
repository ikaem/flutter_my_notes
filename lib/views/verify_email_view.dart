import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        children: <Widget>[
          Text("Please enter your email"),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                print("user: $user");
                await user?.sendEmailVerification();
              },
              child: Text("Send"))
        ],
      ),
    );
  }
}
