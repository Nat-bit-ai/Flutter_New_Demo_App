import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/services/store/cart_service.dart';
import 'package:flutter_app/theme/gebeya_theme.dart';

class CartView extends StatefulWidget {
  /// When true, this widget renders just its body content (no Scaffold or
  /// AppBar of its own) so it can sit inside a parent Scaffold/tab, such as
  /// the Cart tab on the main bottom navigation bar.
  final bool embedded;

  /// Called right after an order is successfully placed and the cart has
  /// been cleared - lets a parent (e.g. the bottom nav) jump back to the
  /// Store tab.
  final VoidCallback? onOrderPlaced;

  const CartView({super.key, this.embedded = false, this.onOrderPlaced});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final _cart = CartService.instance;
  bool _isPlacingOrder = false;

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

  Future<void> _checkout() async {
    if (_cart.items.isEmpty || _isPlacingOrder) return;

    final total = _cart.totalPrice;
    final itemCount = _cart.itemCount;

    // Step 1: let the user review and confirm the order.
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _OrderSummarySheet(
        itemCount: itemCount,
        total: total,
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isPlacingOrder = true);

    // Simulate placing the order with the backend.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final orderNumber = 100000 + Random().nextInt(899999);
    _cart.clear();

    setState(() => _isPlacingOrder = false);

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _OrderSuccessDialog(
        orderNumber: orderNumber,
        total: total,
      ),
    );
    if (!mounted) return;
    widget.onOrderPlaced?.call();
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);
    if (widget.embedded) {
      return body;
    }
    return Scaffold(
      backgroundColor: GebeyaColors.cream,
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (_cart.items.isNotEmpty)
            IconButton(
              onPressed: _cart.clear,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear cart',
            ),
        ],
      ),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    final items = _cart.items;

    if (items.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          Icon(Icons.shopping_bag_outlined, size: 56, color: GebeyaColors.textMuted),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(
                color: GebeyaColors.ink,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Browse the store and add something you like.',
              textAlign: TextAlign.center,
              style: TextStyle(color: GebeyaColors.textMuted, fontSize: 13),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (widget.embedded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Text(
                  '${_cart.itemCount} ${_cart.itemCount == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    color: GebeyaColors.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _cart.clear,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(foregroundColor: GebeyaColors.danger),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: GebeyaColors.creamBorder),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 64,
                        height: 64,
                        color: GebeyaColors.creamSoft,
                        padding: const EdgeInsets.all(6),
                        child: Image.network(
                          item.product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: GebeyaColors.textMuted,
                          ),
                        ),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                              color: GebeyaColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: GebeyaColors.orange,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: GebeyaColors.creamSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => _cart.decrementQuantity(item.product.id),
                            icon: const Icon(Icons.remove_rounded, size: 18),
                            color: GebeyaColors.ink,
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => _cart.incrementQuantity(item.product.id),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            color: GebeyaColors.ink,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: GebeyaColors.creamBorder)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: GebeyaColors.textMuted,
                      ),
                    ),
                    Text(
                      '\$${_cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: GebeyaColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isPlacingOrder ? null : _checkout,
                    icon: _isPlacingOrder
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.lock_outline_rounded, size: 18),
                    label: Text(_isPlacingOrder ? 'Placing order...' : 'Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderSummarySheet extends StatelessWidget {
  final int itemCount;
  final double total;

  const _OrderSummarySheet({required this.itemCount, required this.total});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: GebeyaColors.creamBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Confirm your order',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: GebeyaColors.ink,
              ),
            ),
            const SizedBox(height: 16),
            _summaryRow('Items', '$itemCount'),
            const SizedBox(height: 8),
            _summaryRow('Shipping', 'Free'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: GebeyaColors.creamBorder, height: 1),
            ),
            _summaryRow('Total', '\$${total.toStringAsFixed(2)}', emphasize: true),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Place order'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool emphasize = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: emphasize ? GebeyaColors.ink : GebeyaColors.textMuted,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            fontSize: emphasize ? 16 : 13.5,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: emphasize ? GebeyaColors.ink : GebeyaColors.textMuted,
            fontWeight: FontWeight.w800,
            fontSize: emphasize ? 16 : 13.5,
          ),
        ),
      ],
    );
  }
}

class _OrderSuccessDialog extends StatelessWidget {
  final int orderNumber;
  final double total;

  const _OrderSuccessDialog({required this.orderNumber, required this.total});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: GebeyaColors.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: GebeyaColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 18),
            const Text(
              'Order placed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: GebeyaColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order #$orderNumber • \$${total.toStringAsFixed(2)}',
              style: const TextStyle(color: GebeyaColors.textMuted, fontSize: 13.5),
            ),
            const SizedBox(height: 6),
            const Text(
              "We've received your order and it's on its way.",
              textAlign: TextAlign.center,
              style: TextStyle(color: GebeyaColors.textMuted, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
