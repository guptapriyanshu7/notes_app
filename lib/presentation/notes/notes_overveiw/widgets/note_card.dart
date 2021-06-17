import 'package:another_flushbar/flushbar_helper.dart';
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
    return BlocListener<NoteActorBloc, NoteActorState>(
      listener: (context, state) {
        state.maybeMap(
          deleteFailure: (_) => FlushbarHelper.createError(
            message: _.failure.maybeMap(
              insufficientPermission: (_) => 'Insufficient permissions ❌',
              unableToDelete: (_) =>
                  "Couldn't delete the note. Was it deleted from another device?",
              orElse: () => 'Unexpected error. Please, contact support.',
            ),
          ).show(context),
          orElse: () => null,
        );
      },
      child: Card(
        color: note.color.getOrCrash(),
        child: InkWell(
          onTap: () => context.pushRoute(NoteFormRoute(editNote: note)),
          onLongPress: () {
            final noteActorBloc = context.read<NoteActorBloc>();
            _showDeletionDialog(context, noteActorBloc);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.body.getOrCrash(),
                  style: const TextStyle(fontSize: 15),
                ),
                if (note.todos.length > 0) SizedBox(height: 4),
                Wrap(
                  spacing: 8,
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
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context, NoteActorBloc noteActorBloc) {
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
              noteActorBloc.add(NoteActorEvent.deleted(note));
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          todo.done ? Icons.check_box : Icons.check_box_outline_blank,
          color: todo.done
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        Text(
          todo.name.getOrCrash(),
        ),
      ],
    );
  }
}
