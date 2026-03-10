import 'package:flutter/material.dart';
import 'package:flutter_application_14/constants/app_constants.dart';
import 'package:flutter_application_14/providers/app_provider.dart';
import 'package:flutter_application_14/screens/order_success_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = "UPI";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    double subtotal = provider.subtotal;
    double deliveryFee = subtotal > 0 ? 10.00 : 0.00;
    double tax = subtotal > 0 ? subtotal * 0.05 : 0.00;
    double totalAmount = subtotal + deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).colorScheme.onSurface),
        title: Text(
          "Payment Method",
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Payment Method",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            // UPI Section
            _buildSectionHeader("UPI Options"),
            _buildPaymentOption("Google Pay", "UPI ID: user@okaxis", "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-pay-icon.png"),
            _buildPaymentOption("PhonePe", "UPI ID: user@ybl", "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/phonepe-logo-icon.png"),
            _buildPaymentOption("Paytm", "UPI ID: user@paytm", "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/paytm-icon.png"),
            
            const SizedBox(height: 24),
            
            // Card Section
            _buildSectionHeader("Credit / Debit Cards"),
            _buildPaymentOption("HDFC Bank Card", "XXXX XXXX XXXX 4521", "https://uxwing.com/wp-content/themes/uxwing/download/logotypes/visa-icon.png"),
            _buildPaymentOption("Add New Card", "", null, isAction: true),
            
            const SizedBox(height: 24),
            
            // Other Options
            _buildSectionHeader("Other Options"),
            _buildPaymentOption("Net Banking", "All major banks supported", null, iconData: Icons.account_balance_outlined),
            _buildPaymentOption("Wallet", "Paytm / Amazon Pay / PhonePe", null, iconData: Icons.account_balance_wallet_outlined),
            _buildPaymentOption("Cash on Delivery (COD)", "Pay when you receive", null, iconData: Icons.money_outlined),
            
            const SizedBox(height: 40),
            
            // Order Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                  _buildSummaryRow("Shipping", "\$${deliveryFee.toStringAsFixed(2)}"),
                  _buildSummaryRow("Tax (5%)", "\$${tax.toStringAsFixed(2)}"),
                  const Divider(height: 24),
                  _buildSummaryRow("Total Amount", "\$${totalAmount.toStringAsFixed(2)}", isTotal: true),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Finalize order
                  provider.addOrder(totalAmount);
                  final newOrder = provider.orders.first;
                  
                  // Navigate to success
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessScreen(order: newOrder),
                    ),
                    (route) => route.isFirst, // Go back to home after success
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Pay Now",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, String? imageUrl, {bool isAction = false, IconData? iconData}) {
    bool isSelected = _selectedPaymentMethod == title;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppConstants.primaryColor : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: imageUrl != null 
            ? Image.network(imageUrl, errorBuilder: (c, e, s) => const Icon(Icons.payment))
            : Icon(iconData ?? (isAction ? Icons.add_circle_outline : Icons.payment), color: AppConstants.primaryColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isAction ? FontWeight.bold : FontWeight.w500,
            color: isAction ? AppConstants.primaryColor : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle.isNotEmpty ? Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
        ) : null,
        trailing: isAction 
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : Radio<String>(
              value: title,
              groupValue: _selectedPaymentMethod,
              activeColor: AppConstants.primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
        onTap: () {
          if (!isAction) {
            setState(() {
              _selectedPaymentMethod = title;
            });
          }
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Theme.of(context).colorScheme.onSurface : Colors.grey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppConstants.primaryColor : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
