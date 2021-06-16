import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/application/auth/auth_bloc.dart';
import 'package:notes_app/application/notes/note_actor/note_actor_bloc.dart';
import 'package:notes_app/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:notes_app/injection.dart';
import 'package:notes_app/presentation/notes/notes_overveiw/widgets/notes_overview_body.dart';
import 'package:notes_app/presentation/notes/notes_overveiw/widgets/uncompleted_todo_switch.dart';
import 'package:notes_app/presentation/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<NoteWatcherBloc>()..add(NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeMap(
            unauthenticated: (_) => context.replaceRoute(SignInRoute()),
            orElse: () {},
          );
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: [
              UncompletedTodoSwitch(),
            ],
          ),
          body: NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.pushRoute(NoteFormRoute()),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
