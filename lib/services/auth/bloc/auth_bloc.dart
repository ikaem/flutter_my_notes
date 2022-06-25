import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(null));
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.create(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();

      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        return;
      }
      if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
        return;
      }

      emit(AuthStateLoggedIn(user));
    });

    on<AuthEventLogin>((event, emit) async {
      // emit(const AuthStateLoading());
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);
        if (!user.isEmailVerified) {
          // not sure there is no exception here that is needed
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification());
          return;
        }
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        // emit(AuthStateLoginFailure(e));
        // print(e);
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      // emit(const AuthStateLoading());

      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        // emit(AuthStateLogoutFailure(e));
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
