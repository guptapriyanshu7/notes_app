import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes_app/application/notes/note_watcher/note_watcher_bloc.dart';

class UncompletedTodoSwitch extends HookWidget {
  const UncompletedTodoSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showUncompletedTodos = useState(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkResponse(
        onTap: () {
          showUncompletedTodos.value = !showUncompletedTodos.value;
          context.read<NoteWatcherBloc>().add(
                showUncompletedTodos.value
                    ? NoteWatcherEvent.watchUnCompletedStarted()
                    : NoteWatcherEvent.watchAllStarted(),
              );
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 100),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: showUncompletedTodos.value
              ? Icon(
                  Icons.check_box_outline_blank,
                  key: Key('show-uncompleted'),
                )
              : Icon(
                  Icons.indeterminate_check_box,
                  key: Key('show-all'),
                ),
        ),
      ),
    );
  }
}
