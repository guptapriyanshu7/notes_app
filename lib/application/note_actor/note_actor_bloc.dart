import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/domain/notes/i_note_repository.dart';
import 'package:notes_app/domain/notes/note.dart';
import 'package:notes_app/domain/notes/note_failure.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(_Initial());

  @override
  Stream<NoteActorState> mapEventToState(
    NoteActorEvent event,
  ) async* {
    yield* event.map(
      deleted: (e) async* {
        yield NoteActorState.actionInProgress();
        final possibleFailure = await _noteRepository.delete(e.note);
        yield possibleFailure.fold(
          (f) => NoteActorState.deleteFailure(f),
          (_) => NoteActorState.deleteSuccess(),
        );
      },
    );
  }
}
