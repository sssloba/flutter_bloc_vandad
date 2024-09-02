import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_vandad/bloc/app_bloc.dart';
import 'package:flutter_bloc_vandad/bloc/app_event.dart';
import 'package:flutter_bloc_vandad/dialogs/delete_account_dialog.dart';
import 'package:flutter_bloc_vandad/dialogs/logout_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            await showLogOutDialog(context).then((value) {
              if (value && context.mounted) {
                // Value will be true if 'Log out' button has been pressed.
                context.read<AppBloc>().add(
                      const AppEventLogOut(),
                    );
              }
            });
            break;
          case MenuAction.deleteAccount:
            await showDeleteAccountDialog(context).then((value) {
              if (value && context.mounted) {
                // Value will be true if  'Delete account' button has been pressed.
                context.read<AppBloc>().add(
                      const AppEventDeleteAccount(),
                    );
              }
            });
            break;
        }
      },
      itemBuilder: (context) {
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
      },
    );
  }
}
