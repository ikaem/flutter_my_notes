// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/counter/counter_home_page.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/edit_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp());
  runApp(MaterialApp(
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
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
      // homeRoute: (context) => const CounterHomePage(),
      // homeRoute: (context) => const HomePage(),
      homeRoute: (context) => BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(FirebaseAuthProvider()),
            child: const HomePage(),
          ),
      // loginRoute: (context) => const LoginView(),
      // registerRoute: (context) => const RegisterView(),
      // notesRoute: (context) => const NotesView(),
      // verifyEmailRoute: (context) => const VerifEmailView(),
      editNoteRoute: (context) => const EditNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    // return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!state.isLoading) {
          LoadingScreen().hide();
          return;
        }

        LoadingScreen().show(
            context: context,
            text: state.loadingText ?? "Please wait a bit...");
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) return const NotesView();
        if (state is AuthStateNeedsVerification) return const VerifEmailView();
        if (state is AuthStateLoggedOut) return const LoginView();
        if (state is AuthStateRegistering) return const RegisterView();
        if (state is AuthStateForgotPassword) return const ForgotPassword();
        return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator.adaptive()));
      },
    );

    // return FutureBuilder(
    //     future: AuthService.firebase().initialize(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return Text("There was error with connecting to Firebase");
    //       }

    //       switch (snapshot.connectionState) {
    //         case ConnectionState.done:
    //           // gettomg current user
    //           // final auth = FirebaseAuth.instance;
    //           // final currentUser = auth.currentUser;
    //           final auth = AuthService.firebase();
    //           final currentUser = AuthService.firebase().currentUser;
    //           final isEmailVerified = currentUser?.isEmailVerified ?? false;

    //           print("this is current user: ${currentUser}");

    //           // FirebaseAuth.instance.signOut();
    //           if (currentUser == null) return LoginView();
    //           if (!isEmailVerified) {
    //             return VerifEmailView();
    //           }
    //           return NotesView();

    //         // return Text("Not email verified");

    //         default:
    //           return Container(
    //               color: Colors.white,
    //               child: Center(child: CircularProgressIndicator.adaptive()));
    //       }
    //     });
  }
}
