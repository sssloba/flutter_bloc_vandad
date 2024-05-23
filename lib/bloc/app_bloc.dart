import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_vandad/auth/auth_error.dart';
import 'package:flutter_bloc_vandad/bloc/app_event.dart';
import 'package:flutter_bloc_vandad/bloc/app_state.dart';
import 'package:flutter_bloc_vandad/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    //
    on<AppEventGoToRegistration>((event, emit) {
      // no need to be async
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
        ),
      );
    });

    //
    on<AppEventLogin>((event, emit) async {
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      // log the user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // get images
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
        emit(AppStateLoggedOut(
          isLoading: false,
          authError: AuthError.from(e),
        ));
      }
    });

    //
    on<AppEventGoToLogin>((event, emit) {
      // no need to be async
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    //
    on<AppEventRegister>((event, emit) async {
      //start loading
      emit(
        const AppStateIsInRegistrationView(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        // cretae user
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(
          AppStateLoggedIn(
            user: credential.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // log out event
    on<AppEventLogOut>(
      (event, emit) async {
        //start loading
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the UI
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );

    // initialize event
    on<AppEventInitialize>(
      (event, emit) async {
        // get the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } else {
          // get user's uploaded images
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              images: images,
              user: user,
              isLoading: false,
            ),
          );
        }
      },
    );

    // handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log the user out if we don't have a current user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
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
          await item.delete().catchError((_) {}); // maybe handle the error?
        }
        // delete folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        // delete the user
        await user.delete();
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the UI
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
              authError: AuthError.from(e)),
        );
      } on FirebaseException {
        // we might not br able to delete the folder
        // log te usder out
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      }
    });

    // handle uploading images
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      // log user out if we don't have an actual user in app state
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      //start the loading process
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );
      // upload file
      final file = File(event.filePathToUpload);
      await uploadImage(
        file: file,
        userId: user.uid,
      );
      // after upload is complete, grab the latest file references
      final images = await _getImages(user.uid);
      // emit the new images and turn off loading
      emit(
        AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ),
      );
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResault) => listResault.items);
}
