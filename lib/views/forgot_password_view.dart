import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is! AuthStateForgotPassword) return;
        if (state.hasSentEmail) {
          _emailController.clear();
          await showPasswordResetSentDialog(context);
          return;
        }
        if (state.exception != null) {
          await showErrorDialog(context, "Error sending link");
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Forgot your password")),
        body: Padding(
          padding: EdgeInsets.all(17),
          child: Column(
            children: <Widget>[
              Text("Enter your email"),
              TextField(
                decoration: InputDecoration(hintText: "Enter email"),
                autocorrect: false,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: Text("Send")),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: Text("Back to main")),
            ],
          ),
        ),
      ),
    );
  }
}
