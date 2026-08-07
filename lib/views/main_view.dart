import 'package:flutter/material.dart';
import 'package:flutter_app/services/store/cart_service.dart';
import 'package:flutter_app/theme/gebeya_theme.dart';
import 'package:flutter_app/views/store/cart_view.dart';
import 'package:flutter_app/views/store/products_view.dart';
import 'package:flutter_app/views/store/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _cart = CartService.instance;
  int _selectedIndex = 0;

  static const _titles = ['Store', 'My Cart', 'Profile'];

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

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GebeyaColors.cream,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const ProductsView(),
          CartView(
            embedded: true,
            onOrderPlaced: () => setState(() => _selectedIndex = 0),
          ),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront_rounded),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${_cart.itemCount}'),
              isLabelVisible: _cart.itemCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              label: Text('${_cart.itemCount}'),
              isLabelVisible: _cart.itemCount > 0,
              child: const Icon(Icons.shopping_cart_rounded),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
