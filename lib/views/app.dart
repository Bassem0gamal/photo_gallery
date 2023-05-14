import 'package:bloc_course_with_firebase/bloc/app_bloc.dart';
import 'package:bloc_course_with_firebase/bloc/app_event.dart';
import 'package:bloc_course_with_firebase/bloc/app_state.dart';
import 'package:bloc_course_with_firebase/dialogs/show_auth_error.dart';
import 'package:bloc_course_with_firebase/loading/loading_screen.dart';
import 'package:bloc_course_with_firebase/views/login_view.dart';
import 'package:bloc_course_with_firebase/views/photo_gallery_view.dart';
import 'package:bloc_course_with_firebase/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance()
                  .show(context: context, text: 'Loading...');
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthError(authError: authError, context: context);
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              // this shouldn't happen!
              return Container();
            }
          },
        ),
      ),
    );
  }
}
