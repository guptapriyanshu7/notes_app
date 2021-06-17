import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_app/presentation/notes/note_form/misc/form_todos_x.dart';
import 'package:notes_app/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        context.formTodos = state.note.todos.value.fold(
          (l) => listOf<TodoItemPrimitive>(),
          (todoItemList) => todoItemList.map(
            (todoItem) => TodoItemPrimitive.fromDomain(todoItem),
          ),
        );
      },
      buildWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          leading: Icon(Icons.add),
          title: Text('Add Todo'),
          onTap: () {
            context.formTodos =
                context.formTodos.plusElement(TodoItemPrimitive.empty());
            context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.formTodos));
          },
        );
      },
    );
  }
}
