import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc_vandad/auth/auth_error.dart';
import 'package:flutter_bloc_vandad/dialogs/generic_dialog.dart';

Future<void> showAuthErrorDialog(
  BuildContext context,
  AuthError authError,
) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
