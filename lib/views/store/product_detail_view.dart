import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/services/store/cart_service.dart';
import 'package:flutter_app/theme/gebeya_theme.dart';

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
      backgroundColor: GebeyaColors.cream,
      appBar: AppBar(title: const Text('Product Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              color: GebeyaColors.creamSoft,
              padding: const EdgeInsets.all(24),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  size: 60,
                  color: GebeyaColors.textMuted,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      color: GebeyaColors.orange,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: GebeyaColors.ink,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: GebeyaColors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating.rate} (${product.rating.count} reviews)',
                        style: const TextStyle(color: GebeyaColors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: GebeyaColors.ink,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: GebeyaColors.ink,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      height: 1.5,
                      color: GebeyaColors.textMuted,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.w800, color: GebeyaColors.ink),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: GebeyaColors.creamSoft,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: GebeyaColors.creamBorder),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove_rounded),
                              color: GebeyaColors.ink,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: GebeyaColors.ink,
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(Icons.add_rounded),
                              color: GebeyaColors.ink,
                            ),
                          ],
                        ),
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
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: GebeyaColors.creamBorder)),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              CartService.instance.addToCart(product, quantity: _quantity);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${product.title} to cart')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart_rounded, color: GebeyaColors.orange),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
        ),
      ),
    );
  }
}
