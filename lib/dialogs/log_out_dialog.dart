import 'package:bloc_course_with_firebase/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content:
    "Are you sure you want to log out?",
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
