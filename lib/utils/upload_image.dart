import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../bloc/app_event.dart';

Future<bool> upLoadImage({required File file, required String userId}) =>
    FirebaseStorage.instance
        .ref(userId)
        .child(const Uuid().v4())
        .putFile(file)
        .then((_) => true)
        .catchError((_) => false);


 upLoad(String imagePath, BuildContext context) {
  context.read().add(
    AppEventUpLoadImage(filePathToUpload: imagePath),
  );
}
