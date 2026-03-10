import 'package:flutter/material.dart';
import 'package:flutter_application_14/widgets/fade_in_network_image.dart';
import 'package:flutter_application_14/constants/app_constants.dart';
import 'package:flutter_application_14/providers/app_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_14/screens/order_success_screen.dart';
import 'package:flutter_application_14/screens/payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final cartItems = provider.cartItems;
    
    double subtotal = provider.subtotal;
    double deliveryFee = subtotal > 0 ? 10.00 : 0.00;
    double tax = subtotal > 0 ? subtotal * 0.05 : 0.00; // 5% tax example
    double total = subtotal + deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cartItems.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  "Your cart is empty",
                  style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 16),
                ),
              ],
            ),
          )
        : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      // Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                         child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: FadeInNetworkImage(
                            imageUrl: item.product.imageUrl,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                             Text(
                              "Size: ${item.size.toInt()}",
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "\$${item.product.price.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 16, color: Theme.of(context).colorScheme.onSurface),
                              onPressed: () {
                                provider.decrementCartItem(item);
                              },
                            ),
                            Text(
                              "${item.quantity}",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 16, color: Theme.of(context).colorScheme.onSurface),
                              onPressed: () {
                                provider.incrementCartItem(item);
                              },
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
          
          // Order Summary
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSummaryRow(context, "Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                const SizedBox(height: 12),
                _buildSummaryRow(context, "Fee Delivery", "\$${deliveryFee.toStringAsFixed(2)}"),
                const SizedBox(height: 12),
                _buildSummaryRow(context, "Total Tax", "\$${tax.toStringAsFixed(2)}"),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                 _buildSummaryRow(context, "Total", "\$${total.toStringAsFixed(2)}", isTotal: true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Check Out",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 14),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isTotal ? AppConstants.primaryColor : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
