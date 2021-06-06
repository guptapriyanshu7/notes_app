import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_app/domain/auth/i_auth_facade.dart';
import 'package:notes_app/domain/auth/value_objects.dart';
import 'package:notes_app/domain/auth/auth_failure.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;
  SignInFormBloc(this._authFacade) : super(SignInFormState.initial());

  @override
  Stream<SignInFormState> mapEventToState(
    SignInFormEvent event,
  ) async* {
    yield* event.map(
      emailChanged: (e) async* {
        yield state.copyWith(
          emailAddress: EmailAddress(e.emailStr),
          authFailureOrSuccessOption: None(),
        );
      },
      passwordChanged: (e) async* {
        yield state.copyWith(
          password: Password(e.passwordStr),
          authFailureOrSuccessOption: None(),
        );
      },
      registerWithEmailAndPasswordPressed: (e) async* {
        yield* _chooseRegisterOrSignIn(
          _authFacade.registerWithEmailAndPassword,
        );
      },
      signInWithEmailAndPasswordPressed: (e) async* {
        _chooseRegisterOrSignIn(
          _authFacade.signInWithEmailAndPassword,
        );
      },
      signInWithGooglePressed: (e) async* {
        yield state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: None(),
        );
        final failureOrSuccess = await _authFacade.signInWithGoogle();
        yield state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: Some(failureOrSuccess),
        );
      },
    );
  }

  Stream<SignInFormState> _chooseRegisterOrSignIn(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
  ) async* {
    Either<AuthFailure, Unit>? failureOrSuccess;
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    if (isEmailValid && isPasswordValid) {
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: None(),
      );
      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    yield state.copyWith(
      // TODO: showError true even if email and password valid
      showErrorMessages: true,
      isSubmitting: false,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }
}
