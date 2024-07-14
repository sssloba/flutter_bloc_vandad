import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_vandad/bloc/app_bloc.dart';
import 'package:flutter_bloc_vandad/bloc/app_event.dart';
import 'package:flutter_bloc_vandad/bloc/app_state.dart';
import 'package:flutter_bloc_vandad/dialogs/auth_error_dialog.dart';
import 'package:flutter_bloc_vandad/loading/loading_screen.dart';
import 'package:flutter_bloc_vandad/views/login_view.dart';
import 'package:flutter_bloc_vandad/views/photo_gallery_view.dart';
import 'package:flutter_bloc_vandad/views/register_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (BuildContext context, AppState appState) {
            if (appState.isLoading) {
              LoadingScreen.instace().show(
                context: context,
                text: 'Loading ...',
              );
            } else {
              LoadingScreen.instace().hide();
            }

            final authError = appState.authError;
            if (authError != null) {
              // even if this is a Future we don't have to await because there is no value to return
              showAuthErrorDialog(
                context,
                authError,
              );
            }
          },
          builder: (BuildContext context, AppState appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              // this shoul never happen
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
