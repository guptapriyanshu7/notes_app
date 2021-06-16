import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_app/domain/core/unique_id_value_object.dart';
import 'package:notes_app/domain/notes/todo_item.dart';
import 'package:notes_app/domain/notes/value_objects.dart';

part 'todo_item_presentation_classes.freezed.dart';

@freezed
class TodoItemPrimitive with _$TodoItemPrimitive {
  const TodoItemPrimitive._();

  const factory TodoItemPrimitive({
    required UniqueId id,
    required String name,
    required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.fromDomain(TodoItem todo) => TodoItemPrimitive(
        id: todo.id,
        name: todo.name.getOrCrash(),
        done: todo.done,
      );

  factory TodoItemPrimitive.empty() => TodoItemPrimitive(
        id: UniqueId(),
        name: '',
        done: false,
      );

  TodoItem toDomain() => TodoItem(
        id: id,
        name: TodoName(name),
        done: done,
      );
}
