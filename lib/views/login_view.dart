import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/extensions/build_context/loc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/dev/dev_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import '../utilities/show_error_dialog.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // final closeDialog = _closeDialogHandle;

        if (state is! AuthStateLoggedOut) {
          return;
        }

// if state is not loading, and close dialog is not null, it means we should close the dialog
        // if (!state.isLoading && closeDialog != null) {
        //   closeDialog();
        //   _closeDialogHandle = null;
        //   // not sure if return is a proper thing here
        //   // return;
        // } else if (state.isLoading && closeDialog == null) {
        //   _closeDialogHandle =
        //       showLoadingDialog(context: context, text: "Loading...");
        //   return;
        // }

        if (state.exception is UserNotFoundAuthException) {
          await showErrorDialog(context, "User not found");
          return;
        }

        if (state.exception is WrongPasswordAuthException) {
          await showErrorDialog(context, "Incorrect credentials");
          return;
        }

        if (state.exception is GenericAuthException) {
          await showErrorDialog(context, "There was an issue logging you in");
          return;
        }
      },
      child: Scaffold(
        // appBar: AppBar(title: const Text("Login")),
        // appBar: AppBar(title: Text(AppLocalizations.of(context)!.my_title)),
        appBar: AppBar(title: Text(context.loc.my_title(2))),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text("Enter your email and password"),
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
                  // final navigator = Navigator.of(context);

                  context.read<AuthBloc>().add(AuthEventLogin(email, password));

                  // try {

                  // await AuthService.firebase()
                  //     .logIn(email: email, password: password);
                  // final user = AuthService.firebase().currentUser;
                  // DevService().log("hello");

                  // if (user?.isEmailVerified == false) {
                  //   navigator.pushNamedAndRemoveUntil(
                  //       verifyEmailRoute, (route) => false);
                  //   return;
                  // }
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil("/notes", (route) => false);
                  // https://stackoverflow.com/questions/69466478/waiting-asynchronously-for-navigator-push-linter-warning-appears-use-build
                  // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
                  // navigator.pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  // } on UserNotFoundAuthException {
                  //   await showErrorDialog(context, "User not found");
                  // } on WrongPasswordAuthException {
                  //   await showErrorDialog(context, "Incorrect credentials");
                  // } on GenericAuthException {
                  //   await showErrorDialog(
                  //       context, "There was an issue logging you in");
                  // }
                },
                child: const Text("Login"),
              ),
              // BlocListener<AuthBloc, AuthState>(
              //   listener: (context, state) async {
              //     DevService().log(state);
              //     if (state is! AuthStateLoggedOut) {
              //       return;
              //     }

              //     DevService().log(state.exception!);
              //     if (state.exception is UserNotFoundAuthException) {
              //       await showErrorDialog(context, "User not found");
              //       return;
              //     }

              //     if (state.exception is WrongPasswordAuthException) {
              //       await showErrorDialog(context, "Incorrect credentials");
              //       return;
              //     }

              //     await showErrorDialog(
              //         context, "There was an issue logging you in");
              //   },
              //   child: TextButton(
              //     onPressed: () async {
              //       final email = _emailController.text;
              //       final password = _passwordController.text;
              //       // final navigator = Navigator.of(context);

              //       context.read<AuthBloc>().add(AuthEventLogin(email, password));

              //       // try {

              //       // await AuthService.firebase()
              //       //     .logIn(email: email, password: password);
              //       // final user = AuthService.firebase().currentUser;
              //       // DevService().log("hello");

              //       // if (user?.isEmailVerified == false) {
              //       //   navigator.pushNamedAndRemoveUntil(
              //       //       verifyEmailRoute, (route) => false);
              //       //   return;
              //       // }
              //       // Navigator.of(context)
              //       //     .pushNamedAndRemoveUntil("/notes", (route) => false);
              //       // https://stackoverflow.com/questions/69466478/waiting-asynchronously-for-navigator-push-linter-warning-appears-use-build
              //       // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
              //       // navigator.pushNamedAndRemoveUntil(notesRoute, (route) => false);
              //       // } on UserNotFoundAuthException {
              //       //   await showErrorDialog(context, "User not found");
              //       // } on WrongPasswordAuthException {
              //       //   await showErrorDialog(context, "Incorrect credentials");
              //       // } on GenericAuthException {
              //       //   await showErrorDialog(
              //       //       context, "There was an issue logging you in");
              //       // }
              //     },
              //     child: const Text("Login"),
              //   ),
              // ),
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).push()
                    // Navigator.of(context)
                    //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);

                    context
                        .read<AuthBloc>()
                        .add(const AuthEventShouldRegister());
                  },
                  child: const Text("Register?")),
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).push()
                    // Navigator.of(context)
                    //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);

                    context
                        .read<AuthBloc>()
                        .add(const AuthEventForgotPassword(null));
                  },
                  child: const Text("Forgot password?"))
            ],
          ),
        ),
      ),
    );
  }
}
