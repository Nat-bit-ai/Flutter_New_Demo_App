import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/services/store/fake_store_api_service.dart';
import 'package:flutter_app/views/store/product_detail_view.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final _api = FakeStoreApiService.instance;
  final _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = const ['All'];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final products = await _api.getAllProducts();
      final categories = await _api.getCategories();
      if (!mounted) return;
      setState(() {
        _allProducts = products;
        _categories = ['All', ...categories];
        _isLoading = false;
      });
      _applyFilters();
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('ProductsView load error: $e\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not load products:\n$e';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesCategory =
            _selectedCategory == 'All' || product.category == _selectedCategory;
        final matchesSearch =
            query.isEmpty || product.title.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          children: [
            const SizedBox(height: 120),
            Icon(Icons.error_outline, size: 48, color: Colors.grey[500]),
            const SizedBox(height: 12),
            Center(child: Text(_errorMessage!)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => _onCategorySelected(category),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredProducts.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 100),
                      Center(child: Text('No products found')),
                    ],
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _ProductCard(product: _filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductDetailView(product: product)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
