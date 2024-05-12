import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'week-password': AuthErrorWeekPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogText: 'Authentication error',
          dialogTitle: 'Unknown authentication error',
        );
}

// auth/no-current-user
@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogText: 'No current user!',
          dialogTitle: 'No current user with this information was found!',
        );
}

// auth/requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogText: 'Requires Recent Login',
          dialogTitle:
              'You need to log out and log back in again in order to perform this operation',
        );
}

// sing in method is not enabled in the firebase console
// auth/operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogText: 'Operation Not Allowed',
          dialogTitle: 'You cannot register using this method at this moment!',
        );
}

// auth/user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogText: 'User Not Found',
          dialogTitle: 'The given uer was not found on the server!',
        );
}

// auth/week-password
@immutable
class AuthErrorWeekPassword extends AuthError {
  const AuthErrorWeekPassword()
      : super(
          dialogText: 'Week Password',
          dialogTitle:
              'Please choose a stronger password consisting of more characters!',
        );
}

// auth/invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogText: 'Invalid Email',
          dialogTitle: 'Please double check your email and try again!',
        );
}

// auth/email-already-in-use
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogText: 'Email Already In Use',
          dialogTitle: 'Please choose another email to register with!',
        );
}
