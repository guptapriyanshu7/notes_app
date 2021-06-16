import 'package:flutter/material.dart';
import 'package:notes_app/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;
  const CriticalFailureDisplay(this.failure, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('😱'),
          Text(
            failure.maybeMap(
              insufficientPermission: (_) => 'Insufficient permissions.',
              orElse: () => 'Unexpected error. \nPlease, contact support.',
            ),
          )
        ],
      ),
    );
  }
}
