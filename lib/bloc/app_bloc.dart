import 'dart:io';

import 'package:bloc_course_with_firebase/auth/auth_error.dart';
import 'package:bloc_course_with_firebase/bloc/app_event.dart';
import 'package:bloc_course_with_firebase/bloc/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventRGoToRegistration>((event, emit) {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
        ),
      );
    });
    on<AppEventLogIn>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(isLoading: true),
        );

        try {
          // log the user in
          final email = event.email;
          final password = event.password;
          final userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          final user = userCredential.user!;
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              user: user,
              images: images,
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    on<AppEventGoToLogin>((event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });
    on<AppEventRegister>(
      (event, emit) async {
        //start loading
        emit(
          const AppStateIsInRegistrationView(isLoading: true),
        );
        final email = event.email;
        final password = event.password;

        try {
          // creating the user
          final credentials = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          emit(AppStateLoggedIn(
              user: credentials.user!, images: const [], isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventInitialize>((event, emit) async {
      // get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      } else {
        // grab the user's images
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
      }
    });

    //log out event
    on<AppEventLogOut>((event, emit) async {
      // start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      // log the user out
      await FirebaseAuth.instance.signOut();
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    // handle account deletion
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // log the user out if we don't have a current user
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }
        // start loading
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );
        // delete the user folder
        try {
          // delete user folder
          final folderContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folderContents.items) {
            await item.delete().catchError((_) {});
          }
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});
          // delete the user
          await user.delete();
          // log the user out
          await FirebaseAuth.instance.signOut();
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          // we might not be able to delete the folder
          // log the user out
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );

    // handle uploading images
    on<AppEventUpLoadImage>(
      (event, emit) async {
        final user = state.user;
        // log user out if we don't have an actual user in the app state
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );
        // uploading the file
        final file = File(event.filePathToUpload);
        await upLoadImage(file: file, userId: user.uid);
        // after uploading is complete, grab the latest file references
        final images = await _getImages(user.uid);
        // emit the new images and turn off loading
        emit(AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ));
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
