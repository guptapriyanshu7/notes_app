import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_app/domain/core/unique_id_value_object.dart';
import 'package:notes_app/domain/notes/note.dart';
import 'package:notes_app/domain/notes/todo_item.dart';
import 'package:notes_app/domain/notes/value_objects.dart';
import 'package:kt_dart/kt.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
class NoteDto with _$NoteDto {
  const NoteDto._();

  const factory NoteDto({
    @JsonKey(ignore: true) String? id,
    required String body,
    required int color,
    required List<TodoItemDto> todos,
    @ServerTimestampConverter() required FieldValue serverTimeStamp,
  }) = _NoteDto;

  factory NoteDto.fromDomain(Note note) => NoteDto(
        id: note.id.getOrCrash(),
        body: note.body.getOrCrash(),
        color: note.color.getOrCrash().value,
        todos: note.todos
            .getOrCrash()
            .map((todo) => TodoItemDto.fromDomain(todo))
            .asList(),
        serverTimeStamp: FieldValue.serverTimestamp(),
      );

  Note toDomain() => Note(
        id: UniqueId.fromUniqueString(id!),
        body: NoteBody(body),
        color: NoteColor(Color(color)),
        todos: List3(todos.map((dto) => dto.toDomain()).toImmutableList()),
      );

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  factory NoteDto.fromFirestore(DocumentSnapshot doc) =>
      NoteDto.fromJson(doc.data() as Map<String, dynamic>)
          .copyWith(id: doc.id);
}

class ServerTimestampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimestampConverter();

  @override
  FieldValue fromJson(Object json) {
    return FieldValue.serverTimestamp();
  }

  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
class TodoItemDto with _$TodoItemDto {
  const TodoItemDto._();

  const factory TodoItemDto({
    required String id,
    required String name,
    required bool done,
  }) = _TodoItemDto;

  factory TodoItemDto.fromDomain(TodoItem todo) => TodoItemDto(
        id: todo.id.getOrCrash(),
        name: todo.name.getOrCrash(),
        done: todo.done,
      );

  TodoItem toDomain() => TodoItem(
        id: UniqueId.fromUniqueString(id),
        name: TodoName(name),
        done: done,
      );

  factory TodoItemDto.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDtoFromJson(json);
}
