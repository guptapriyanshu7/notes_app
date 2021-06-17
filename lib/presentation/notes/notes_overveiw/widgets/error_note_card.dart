import 'package:flutter/material.dart';
import 'package:notes_app/domain/notes/note.dart';

class ErrorNoteCard extends StatelessWidget {
  final Note note;
  const ErrorNoteCard(this.note, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).errorColor.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Invalid note, please, contact support',
            ),
            const SizedBox(height: 2),
            Text(
              'Details for nerds:',
            ),
            Text(
              note.failureOption.fold(() => '', (f) => f.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
