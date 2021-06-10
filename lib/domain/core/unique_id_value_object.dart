import 'package:notes_app/domain/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:notes_app/domain/core/value_objects.dart';
import 'package:uuid/uuid.dart';

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UniqueId() {
    final String uniqueId = Uuid().v4();
    return UniqueId._(Right(uniqueId));
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    return UniqueId._(Right(uniqueId));
  }

  const UniqueId._(this.value);
}
