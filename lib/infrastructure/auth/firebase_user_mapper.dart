import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:notes_app/domain/auth/user.dart';
import 'package:notes_app/domain/core/unique_id_value_object.dart';

extension FirebaseUserDomainX on firebaseUser.User {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
}
