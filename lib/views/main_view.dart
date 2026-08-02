import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/enums/menu_action.dart';
import 'package:flutter_app/services/auth/auth_service.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch(value){
              case MenuAction.logout:
                final shouldlogout = await showLogOutDialog(context);
                if (shouldlogout){
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
            }
          },
          itemBuilder: (context){
            return
            const [PopupMenuItem<MenuAction>(
              value : MenuAction.logout,
              child : Text('Log Out'),
            ),
            ];
          },)
        ],
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}


Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}