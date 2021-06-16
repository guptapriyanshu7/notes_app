import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_app/domain/notes/value_objects.dart';

class ColorField extends StatelessWidget {
  const ColorField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (previous, current) =>
          previous.note.color != current.note.color,
      builder: (context, state) {
        return Container(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final indexColor = NoteColor.predefinedColors[index];
              return GestureDetector(
                onTap: () => context.read<NoteFormBloc>().add(
                      NoteFormEvent.colorChanged(indexColor),
                    ),
                child: Material(
                  color: indexColor,
                  elevation: 4,
                  shape: CircleBorder(
                    side: state.note.color.value.fold(
                      (l) => BorderSide.none,
                      (color) => color == indexColor
                          ? BorderSide(width: 1.5)
                          : BorderSide.none,
                    ),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              width: 8,
            ),
            itemCount: NoteColor.predefinedColors.length,
          ),
        );
      },
    );
  }
}
