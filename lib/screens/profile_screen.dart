import 'package:flutter/material.dart';
import 'package:flutter_application_14/constants/app_constants.dart';
import 'package:flutter_application_14/screens/help_center_screen.dart';
import 'package:flutter_application_14/screens/payment_screen.dart';
import 'package:flutter_application_14/providers/app_provider.dart';
import 'package:flutter_application_14/screens/onboarding_screen.dart';
import 'package:flutter_application_14/screens/profile/order_list_screen.dart';
import 'package:flutter_application_14/screens/profile/saved_addresses_screen.dart';
import 'package:flutter_application_14/screens/profile/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Picture
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  final name = provider.userFullName;
                  final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
                  
                  return Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppConstants.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "${name.toLowerCase().replaceAll(' ', '')}@example.com",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Settings List
              _buildProfileOption(
                context: context,
                icon: Icons.shopping_bag_outlined,
                title: "My Orders",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderListScreen()));
                },
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.location_on_outlined,
                title: "Shipping Address",
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedAddressesScreen()));
                },
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.payment,
                title: "Payment Methods",
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
                },
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.settings_outlined,
                title: "Settings",
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                },
              ),
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  return _buildProfileOption(
                    context: context,
                    icon: provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    title: "Dark Mode",
                    onTap: () => provider.toggleTheme(),
                    trailing: Switch(
                      value: provider.isDarkMode,
                      onChanged: (value) => provider.toggleTheme(),
                      activeColor: AppConstants.primaryColor,
                    ),
                  );
                },
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.help_outline,
                title: "Help Center",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()));
                },
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.logout,
                title: "Logout",
                color: Colors.red,
                onTap: () {
                  final provider = Provider.of<AppProvider>(context, listen: false);
                  provider.logout();
                  
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppConstants.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color ?? AppConstants.primaryColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
