import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_app/domain/core/unique_id_value_object.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required UniqueId id,
  }) = _User;
}