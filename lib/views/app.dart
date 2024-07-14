import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_vandad/bloc/app_bloc.dart';
import 'package:flutter_bloc_vandad/bloc/app_event.dart';

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
      ),
    );
  }
}
