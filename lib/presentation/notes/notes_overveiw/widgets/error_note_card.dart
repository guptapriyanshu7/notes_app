import 'package:flutter/material.dart';
import 'package:notes_app/domain/notes/note.dart';

class ErrorNoteCard extends StatelessWidget {
  final Note note;
  const ErrorNoteCard(this.note, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            'Invalid note, please, contact support',
            style: Theme.of(context)
                .primaryTextTheme
                .bodyText2!
                .copyWith(fontSize: 18),
          ),
          Text(
            note.failureOption.fold(() => '', (f) => f.toString()),
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
