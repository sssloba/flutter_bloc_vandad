import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_vandad/bloc/app_event.dart';
import 'package:flutter_bloc_vandad/bloc/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateLoggedOut(
          isLoading: false,
        ));
}
