import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:notes_app/domain/notes/i_note_repository.dart';
import 'package:notes_app/domain/notes/note_failure.dart';
import 'package:notes_app/domain/notes/note.dart';
import 'package:notes_app/infrastructure/core/firebase_helpers.dart';
import 'package:notes_app/infrastructure/notes/note_dtos.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepositoryImpl implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepositoryImpl(this._firestore);
  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());
      return right(unit);
    } catch (e) {
      if (e is FirebaseException &&
          (e.message?.contains('permission_denied') ?? false)) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        // log.error(e.toString());
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } catch (e) {
      if (e is FirebaseException &&
          (e.message?.contains('permission_denied') ?? false)) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e is FirebaseException &&
          (e.message?.contains('not_found') ?? false)) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());
      return right(unit);
    } catch (e) {
      if (e is FirebaseException &&
          (e.message?.contains('permission_denied') ?? false)) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e is FirebaseException &&
          (e.message?.contains('not_found') ?? false)) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.docs
                .map((doc) => NoteDto.fromFirestore(doc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((e, _) {
      if (e is FirebaseException &&
          (e.message?.contains('permission_denied') ?? false)) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        // log.error(e.toString());
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUnCompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => NoteDto.fromFirestore(doc).toDomain()))
        .map(
          (notes) => right<NoteFailure, KtList<Note>>(
            notes
                .where(
                  (note) => note.todos.getOrCrash().any((todo) => !todo.done),
                )
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((e, _) {
      if (e is FirebaseException &&
          (e.message?.contains('permission_denied') ?? false)) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        // log.error(e.toString());
        return left(const NoteFailure.unexpected());
      }
    });
  }
}
