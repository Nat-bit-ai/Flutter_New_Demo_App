import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/services/store/cart_item.dart';

/// App-wide shopping cart. Kept as a simple ChangeNotifier singleton so no
/// extra state-management package is required - widgets that need to react
/// to cart changes just call `CartService.instance.addListener(...)`.
class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  bool contains(int productId) => _items.containsKey(productId);

  int quantityOf(int productId) => _items[productId]?.quantity ?? 0;

  void addToCart(Product product, {int quantity = 1}) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final item = _items[productId];
    if (item != null) {
      item.quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(int productId) {
    final item = _items[productId];
    if (item != null) {
      item.quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      removeFromCart(productId);
    } else {
      item.quantity -= 1;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
