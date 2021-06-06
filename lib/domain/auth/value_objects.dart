import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/domain/core/failures.dart';
import 'package:notes_app/domain/core/value_validators.dart';

class EmailAddress extends Equatable {
  final Either<ValueFailure<String>, String> value;
  bool isValid() => value.isRight();
  factory EmailAddress(String input) {
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }
  const EmailAddress._(this.value);
  @override
  List<Object> get props => [value];
}

class Password extends Equatable {
  final Either<ValueFailure<String>, String> value;
  bool isValid() => value.isRight();
  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }
  const Password._(this.value);
  @override
  List<Object> get props => [value];
}
