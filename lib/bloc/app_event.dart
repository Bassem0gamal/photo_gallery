import 'package:flutter/cupertino.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventUpLoadImage implements AppEvent {
  final String filePathToUpload;

  const AppEventUpLoadImage({
    required this.filePathToUpload,
  });
}


@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventRGoToRegistration implements AppEvent {
  const AppEventRGoToRegistration();
}

@immutable
class AppEventLogIn implements AppEvent {
  final String email;
  final String password;

  const AppEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}
