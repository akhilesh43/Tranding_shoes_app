import 'package:flutter/material.dart';
import 'package:flutter_application_14/providers/app_provider.dart';
import 'package:flutter_application_14/widgets/fade_in_network_image.dart';
import 'package:flutter_application_14/widgets/banner_slider.dart';
import 'package:flutter_application_14/constants/app_constants.dart';
import 'package:flutter_application_14/data/dummy_data.dart';
import 'package:flutter_application_14/models/product.dart';
import 'package:flutter_application_14/screens/cart_screen.dart';
import 'package:flutter_application_14/screens/favorites_screen.dart';
import 'package:flutter_application_14/screens/product_details_screen.dart';
import 'package:flutter_application_14/screens/profile_screen.dart';
import 'package:flutter_application_14/screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedCategory = "All";
  String _searchQuery = "";
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = dummyProducts;
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = dummyProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
        
        if (!matchesSearch) return false;

        if (_selectedCategory == "All") return true;

        // Check if matches category field (e.g., Running, Basketball)
        if (product.category == _selectedCategory) return true;

        // Check if matches brand in name (e.g., Nike, Adidas)
        if (product.name.toLowerCase().contains(_selectedCategory.toLowerCase())) return true;

        return false;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _filterProducts();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  final name = provider.userFullName;
                  final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
                  
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppConstants.primaryColor,
                        child: Text(
                          initial,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "What are you looking for?",
                    hintStyle: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                    icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryItem("All", _selectedCategory == "All"),
                    _buildCategoryItem("Nike", _selectedCategory == "Nike"), // Assuming your dummy data has these categories
                    _buildCategoryItem("Adidas", _selectedCategory == "Adidas"),
                    _buildCategoryItem("Puma", _selectedCategory == "Puma"),
                    _buildCategoryItem("Reebok", _selectedCategory == "Reebok"),
                    _buildCategoryItem("Running", _selectedCategory == "Running"),
                    _buildCategoryItem("Basketball", _selectedCategory == "Basketball"),
                    _buildCategoryItem("Lifestyle", _selectedCategory == "Lifestyle"),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Auto-sliding Banner
              const BannerSlider(),
              const SizedBox(height: 24),
              
               // Recommendations Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Recommendation",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "See all",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recommendation Grid
              _filteredProducts.isEmpty 
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No products found",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                )
              : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(context, _filteredProducts[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, bool isSelected) {
    return GestureDetector(
      onTap: () => _onCategorySelected(title),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Hero(
                    tag: product.id,
                    child: FadeInNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                       color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    product.category,
                     style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          //color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
