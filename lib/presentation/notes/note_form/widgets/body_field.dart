import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_app/domain/notes/value_objects.dart';

class BodyField extends HookWidget {
  const BodyField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useTextEditingController();
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        _controller.text = state.note.body.getOrCrash();
      },
      child: TextFormField(
        maxLength: NoteBody.maxLength,
        maxLines: null,
        minLines: 5,
        controller: _controller,
        decoration: InputDecoration(
          // counterText: '',
          labelText: 'Note',
        ),
        onChanged: (value) => context.read<NoteFormBloc>().add(
              NoteFormEvent.bodyChanged(value),
            ),
        validator: (_) =>
            context.read<NoteFormBloc>().state.note.body.value.fold(
                (l) => l.maybeMap(
                      orElse: () {},
                      empty: (_) => 'Cannot be empty',
                      exceedingLength: (f) => 'Exceeding length, max: ${f.max}',
                    ),
                (r) => null),
      ),
    );
  }
}
