import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/services/store/cart_service.dart';

class ProductDetailView extends StatefulWidget {
  final Product product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  size: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('${product.rating.rate} (${product.rating.count} reviews)'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(product.description, style: const TextStyle(height: 1.4)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 16)),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              CartService.instance.addToCart(product, quantity: _quantity);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${product.title} to cart')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ),
      ),
    );
  }
}
