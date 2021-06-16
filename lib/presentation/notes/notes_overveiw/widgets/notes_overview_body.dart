import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:notes_app/presentation/notes/notes_overveiw/widgets/critical_failure_display.dart';
import 'package:notes_app/presentation/notes/notes_overveiw/widgets/error_note_card.dart';
import 'package:notes_app/presentation/notes/notes_overveiw/widgets/note_card.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) {
            return Container();
          },
          loadInProgress: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          loadSuccess: (state) {
            return ListView.builder(
              itemBuilder: (_, index) {
                final note = state.notes[index];
                if (note.failureOption.isSome()) {
                  return ErrorNoteCard(note);
                } else {
                  return NoteCard(note);
                }
              },
              itemCount: state.notes.size,
            );
          },
          loadFailure: (state) {
            return CriticalFailureDisplay(state.failure);
          },
        );
      },
    );
  }
}
