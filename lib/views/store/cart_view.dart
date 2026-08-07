import 'package:flutter/material.dart';
import 'package:flutter_app/services/store/cart_service.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
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
    final items = _cart.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              onPressed: _cart.clear,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear cart',
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.product.image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text('\$${item.product.price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _cart.decrementQuantity(item.product.id),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          onPressed: () => _cart.incrementQuantity(item.product.id),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          '\$${_cart.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Checkout is not implemented yet')),
                        );
                      },
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
