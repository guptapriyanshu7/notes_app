import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_app/domain/notes/note.dart';
import 'package:notes_app/injection.dart';
import 'package:notes_app/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:notes_app/presentation/notes/note_form/widgets/add_todo_tile.dart';
import 'package:notes_app/presentation/notes/note_form/widgets/body_field.dart';
import 'package:notes_app/presentation/notes/note_form/widgets/color_field.dart';
import 'package:notes_app/presentation/notes/note_form/widgets/todo_list.dart';
import 'package:notes_app/presentation/routes/router.gr.dart';
import 'package:provider/provider.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editNote;
  const NoteFormPage({this.editNote, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NoteFormBloc>()
        ..add(
          NoteFormEvent.initialized(optionOf(editNote)),
        ),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) =>
            p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () => null,
            (either) {
              either.fold(
                (l) => FlushbarHelper.createError(
                  message: l.maybeMap(
                    insufficientPermission: (_) => 'Insufficient permissions ❌',
                    unableToUpdate: (_) =>
                        "Couldn't update the note. Was it deleted from another device?",
                    orElse: () => 'Unexpected error. Please, contact support.',
                  ),
                ).show(context),
                (r) {
                  context.router.popUntil(
                    (route) =>
                        route.settings.name ==
                        const NotesOverviewRoute().routeName,
                  );
                },
              );
            },
          );
        },
        builder: (context, state) {
          return Stack(
            children: [
              NoteFormPageScaffold(),
              SavingInProgressOverlay(isSaving: state.isSaving),
            ],
          );
        },
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
          )
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
              autovalidateMode: state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    const BodyField(),
                    const ColorField(),
                    const TodoList(),
                    const AddTodoTile(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final isSaving;
  const SavingInProgressOverlay({Key? key, this.isSaving}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Saving',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
