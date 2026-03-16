import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';
import 'package:flutter_products_app/features/settings/presentation/controllers/settings_controller.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductController controller = Get.put(ProductController());
  final TextEditingController searchController = TextEditingController();
  int _selectedNavIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).disabledColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "Error: ${controller.errorMessage.value}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProducts,
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        return Obx(
          () {
            if (_selectedNavIndex == 1) {
              // Wishlist view
              return _buildWishlistView();
            } else if (_selectedNavIndex == 2) {
              // Cart view
              return _buildCartView();
            } else if (_selectedNavIndex == 3) {
              // Settings view
              return _buildSettingsView();
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Search Bar
                  _buildSearchBar(),

                  /// Category Tabs
                  _buildCategoryTabs(),

                  /// Sort & Filter
                  _buildSortFilterBar(),

                  /// Promotional Banner
                  _buildPromoBanner(),

                  /// Featured Products
                  _buildFeaturedSection(),

                  /// Trending Products
                  _buildTrendingSection(),

                  /// Special Offers
                  _buildSpecialOffersSection(),

                  /// New Arrivals
                  _buildNewArrivalsSection(),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: theme.iconTheme.color ?? theme.colorScheme.onSurface,
        ),
        onPressed: () {
          Get.toNamed("/menu");
        },
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Stylish",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.cardColor,
                ),
                child: Icon(Icons.person,
                    color: theme.colorScheme.secondary, size: 20),
              );
            },
          ),
          onPressed: () {
            Get.toNamed("/profile");
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final hintColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7) ?? theme.hintColor;
    final borderColor = theme.dividerColor.withOpacity(0.4);
    final fillColor = theme.inputDecorationTheme.fillColor ?? theme.cardColor;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: "Search any Product...",
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(Icons.search, color: hintColor),
          suffixIcon: Icon(Icons.mic, color: hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: controller.categories.map((category) {
          return Obx(
            () => GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: controller.selectedCategory.value == category
                      ? const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                        )
                      : null,
                  color: controller.selectedCategory.value != category
                      ? Theme.of(context).cardColor
                      : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _getCategoryIcon(category),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: controller.selectedCategory.value == category
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    final theme = Theme.of(context);
    IconData icon;
    switch (category) {
      case "Beauty":
        icon = Icons.face;
        break;
      case "Fashion":
        icon = Icons.shopping_bag;
        break;
      case "Kids":
        icon = Icons.child_care;
        break;
      case "Mens":
        icon = Icons.person;
        break;
      case "Womens":
        icon = Icons.woman;
        break;
      default:
        icon = Icons.category;
    }
    return Icon(
      icon,
      size: 24,
      color: controller.selectedCategory.value == category
          ? Colors.white
          : theme.iconTheme.color?.withOpacity(0.8),
    );
  }

  Widget _buildSortFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "All Featured",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Row(
            children: [
              PopupMenuButton(
                onSelected: controller.selectSort,
                itemBuilder: (context) => controller.sortOptions.map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                child: Row(
                  children: [
                    const Text(
                      "Sort",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.tune,
                        size: 18,
                        color: Theme.of(context)
                            .iconTheme
                            .color
                            ?.withOpacity(0.7)),

                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildFilterBottomSheet(),
                  );
                },
                child: Row(
                  children: [
                    const Text(
                      "Filter",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.filter_list,
                        size: 18,
                        color: Theme.of(context)
                            .iconTheme
                            .color
                            ?.withOpacity(0.7)),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text("Price Range",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Min",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Max",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
              ),
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "50-40% OFF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Now in product\nAll colors",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Shop Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.shopping_bag, color: Colors.white, size: 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    final featured = controller.getFeaturedProducts();
    if (featured.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Deal of the Day",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  const Icon(Icons.timer, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    "22h 58m 20s remaining",
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "View all",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                    Get.to(() => ProductDetailScreen(product: featured[index])),
                child: _buildProductCard(featured[index], 140),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    final trending = controller.getTrendingProducts();
    if (trending.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Trending Products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed("/trending");
                },
                child: const Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: trending.length,
          itemBuilder: (context, index) {
            return _buildProductGridCard(trending[index]);
          },
        ),
      ],
    );
  }

  Widget _buildNewArrivalsSection() {
    final newArrivals = controller.getNewArrivals();
    if (newArrivals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "New Arrivals",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: newArrivals.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Get.to(
                    () => ProductDetailScreen(product: newArrivals[index])),
                child: _buildProductCard(newArrivals[index], 140),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOffersSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Special Offers",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We make sure you get the offer you need at best prices",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.black87),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.withOpacity(0.2),
            ),
            child:
                const Icon(Icons.local_offer, color: Colors.orange, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, double width) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: theme.dividerColor.withOpacity(0.2),
                child: Icon(Icons.image_not_supported,
                    color: theme.disabledColor),
              ),
            ),
          ),
          if (product.onPromotion)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Sale",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: const Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridCard(Product product) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 12,
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.dividerColor.withOpacity(0.2),
                  child: Icon(Icons.image_not_supported,
                      color: theme.disabledColor),
                ),
              ),
            ),
            if (product.onPromotion)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Sale",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: const Color(0xFFFF6B6B),
                          ),
                        ),
                        if (product.rating != null)
                          Row(
                            children: [
                              Icon(Icons.star,
                                  size: 12, color: theme.colorScheme.secondary),
                              Text(
                                "${product.rating}",
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedNavIndex,
      selectedItemColor: const Color(0xFFFF6B6B),
      unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      onTap: (index) {
        setState(() => _selectedNavIndex = index);

        if (index == 1) {
          // Wishlist
          controller.fetchWishlist();
        } else if (index == 3) {
          // Settings
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: "Wishlist",
        ),
        BottomNavigationBarItem(
          icon: Obx(() {
            final cartCount = Get.find<CartController>().cartItems.length;
            return Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
          label: "Cart",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Setting",
        ),
      ],
    );
  }

  Widget _buildWishlistView() {
    return Obx(() {
      if (controller.isWishlistLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.wishlist.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border,
                  size: 64, color: Theme.of(context).disabledColor),
              const SizedBox(height: 16),
              Text('Your wishlist is empty',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16, color: Theme.of(context).disabledColor)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() => _selectedNavIndex = 0);
                },
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: controller.wishlist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = controller.wishlist[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailScreen(product: product));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: Theme.of(context).dividerColor.withOpacity(0.3),
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          controller.toggleWishlist(product.id!);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildCartView() {
    final cartController = Get.find<CartController>();
    return Obx(() {
      if (cartController.cartItems.isEmpty) {
        final theme = Theme.of(context);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 64, color: theme.disabledColor),
              const SizedBox(height: 16),
              Text('Your cart is empty',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16, color: theme.disabledColor)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() => _selectedNavIndex = 0);
                },
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cart Items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, idx) {
                return _buildCartItem(cartController.cartItems[idx]);
              },
            ),
            const SizedBox(height: 16),
            Divider(color: Theme.of(context).dividerColor),

            /// Order Summary
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Summary',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 14)),
                      Obx(() => Text(
                          '₹${cartController.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Fee',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 14)),
                      Obx(() => Text(
                          '₹${cartController.deliveryFee.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Convenience Fee',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 14)),
                      Obx(() => Text(
                          '₹${cartController.convenienceFee.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                  if (cartController.appliedCouponDiscount.value > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                            'Discount (${cartController.appliedCouponCode.value})',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.green))),
                        Obx(() => Text(
                            '-₹${cartController.appliedCouponDiscount.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.green))),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Divider(color: Theme.of(context).dividerColor),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Obx(() => Text(
                          '₹${cartController.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              ),
            ),

            /// Checkout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Proceed to Checkout',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  void _processOrder() {
    final cartController = Get.find<CartController>();

    if (cartController.cartItems.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Create order data
    final orderData = {
      'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      'items': cartController.cartItems
          .map((item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'quantity': item.quantity,
                'price': item.product.price,
                'size': item.selectedSize,
                'subtotal': item.subtotal,
              })
          .toList(),
      'subtotal': cartController.subtotal,
      'deliveryFee': cartController.deliveryFee,
      'convenienceFee': cartController.convenienceFee,
      'discount': cartController.appliedCouponDiscount.value,
      'total': cartController.total,
      'orderDate': DateTime.now().toIso8601String(),
      'status': 'confirmed',
    };

    print('🛒 Processing order with ${cartController.cartItems.length} items');
    print('💰 Order total: ₹${cartController.total.toStringAsFixed(2)}');

    // Save order to local storage (simulate backend)
    _saveOrderToStorage(orderData);

    // Clear cart
    cartController.clearCart();

    // Show success message
    Get.snackbar(
      'Order Placed Successfully! 🎉',
      'Order ID: ${orderData['orderId']}\nTotal: ₹${cartController.total.toStringAsFixed(2)}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate back to home tab
    setState(() => _selectedNavIndex = 0);
  }

  Future<void> _saveOrderToStorage(Map<String, dynamic> orderData) async {
    try {
      // You could save to SharedPreferences or a local database
      // For now, just print the order (simulating backend save)
      print('📦 Order saved: ${orderData['orderId']}');
      print('💰 Total: ₹${orderData['total']}');
      print('📦 Items: ${orderData['items'].length}');

      // In a real app, you would send this to your backend API
      // await orderService.createOrder(orderData);
    } catch (e) {
      print('❌ Error saving order: $e');
    }
  }

  Widget _buildCartItem(CartItem item) {
    final cartController = Get.find<CartController>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: theme.dividerColor.withOpacity(0.2),
                child: Icon(Icons.image_not_supported,
                    color: theme.disabledColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: theme.colorScheme.error),
                      onPressed: () {
                        cartController.removeFromCart(item);
                        Get.snackbar('Removed',
                            '${item.product.name} removed from cart');
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Size: ${item.selectedSize}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: theme.disabledColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () {
                            if (item.quantity > 1) {
                              cartController.updateQuantity(
                                  item, item.quantity - 1);
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: theme.dividerColor.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.quantity.toString(),
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () {
                            cartController.updateQuantity(
                                item, item.quantity + 1);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Text(
                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Delivery by ${DateTime.now().add(const Duration(days: 5)).toString().split(' ')[0]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: theme.disabledColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    final settings = Get.find<SettingsController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Appearance settings
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Obx(
                  () => SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle app theme'),
                    value: settings.isDarkMode.value,
                    onChanged: settings.toggleDarkMode,
                    secondary: const Icon(Icons.dark_mode),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_size),
                  title: const Text('Font Size'),
                  subtitle: Obx(
                    () => Text(
                      'Scale: ${settings.fontScale.value.toStringAsFixed(1)}x',
                    ),
                  ),
                  trailing: Obx(
                    () => SizedBox(
                      width: 130,
                      child: Slider(
                        value: settings.fontScale.value,
                        min: 0.8,
                        max: 1.4,
                        divisions: 6,
                        label: settings.fontScale.value.toStringAsFixed(1),
                        onChanged: settings.setFontScale,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Navigation and account actions
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Account'),
                  subtitle: const Text('View and edit your profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed('/profile'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('Wishlist'),
                  subtitle: const Text('Your saved items'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    setState(() => _selectedNavIndex = 1);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: const Text('Cart'),
                  subtitle: const Text('View your shopping bag'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    setState(() => _selectedNavIndex = 2);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  subtitle: const Text('Sign out of your account'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Add logout logic
                    Get.snackbar('Logged out', 'You have been logged out.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
