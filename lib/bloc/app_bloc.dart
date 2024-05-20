import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
