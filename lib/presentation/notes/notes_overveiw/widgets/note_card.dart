import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/application/notes/note_actor/note_actor_bloc.dart';
import 'package:notes_app/domain/notes/note.dart';
import 'package:notes_app/domain/notes/todo_item.dart';
import 'package:notes_app/presentation/routes/router.gr.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard(this.note, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () => context.pushRoute(NoteFormRoute(editNote: note)),
        onLongPress: () => _showDeletionDialog(context),
        child: Column(
          children: [
            Text(note.body.getOrCrash()),
            Wrap(
              children: note.todos
                  .getOrCrash()
                  .map(
                    (todo) => TodoDisplay(todo),
                  )
                  .asList(),
            )
          ],
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note!'),
        content: Text(
          note.body.getOrCrash(),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteActorBloc>().add(NoteActorEvent.deleted(note));
              Navigator.pop(context);
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todo;
  const TodoDisplay(
    this.todo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          todo.done ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        Text(
          todo.name.getOrCrash(),
        ),
      ],
    );
  }
}
