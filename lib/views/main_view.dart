import 'package:flutter/material.dart';
import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/enums/menu_action.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:flutter_app/services/store/cart_service.dart';
import 'package:flutter_app/views/store/cart_view.dart';
import 'package:flutter_app/views/store/products_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _cart = CartService.instance;

  @override
  void initState() {
    super.initState();
    _cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartView()),
              );
            },
            icon: Badge(
              label: Text('${_cart.itemCount}'),
              isLabelVisible: _cart.itemCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
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
      body: const ProductsView(),
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
