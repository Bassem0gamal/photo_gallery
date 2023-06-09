import 'package:bloc_course_with_firebase/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

import '../auth/auth_error.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'Ok': true,
    },
  );
}
