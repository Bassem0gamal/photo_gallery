import 'package:bloc_course_with_firebase/bloc/app_bloc.dart';
import 'package:bloc_course_with_firebase/bloc/app_event.dart';
import 'package:bloc_course_with_firebase/dialogs/delete_account_dialog.dart';
import 'package:bloc_course_with_firebase/dialogs/log_out_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(onSelected: (value) async {
      switch (value) {
        case MenuAction.logout:
          final shouldLogOut = await showLogOutDialog(context);
          if (shouldLogOut && context.mounted) {
            context.read<AppBloc>().add(
                  const AppEventLogOut(),
                );
          }
          break;
        case MenuAction.deleteAccount:
          final deleteAccount = await showDeleteAccountDialog(context);
          if (deleteAccount && context.mounted) {
            context.read<AppBloc>().add(
                  const AppEventDeleteAccount(),
                );
          }
          break;
      }
    }, itemBuilder: (context) {
      return [
        const PopupMenuItem<MenuAction>(
          value: MenuAction.logout,
          child: Text('Log out'),
        ),
        const PopupMenuItem<MenuAction>(
          value: MenuAction.deleteAccount,
          child: Text('Delete account'),
        ),
      ];
    });
  }
}
