import 'package:bloc_course_with_firebase/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete account',
    content:
        "Are you sure you want to delete your account? You can't undo this operation!",
    optionsBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then((value) => value ?? false);
}
