import 'package:dartz/dartz.dart';
import 'package:notes_app/domain/auth/value_objects.dart';
import 'package:notes_app/domain/auth/auth_failure.dart';
import 'package:notes_app/domain/auth/user.dart';

abstract class IAuthFacade {
  Future<Option<User>> getSignedInUser();
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<void> signOut();
}