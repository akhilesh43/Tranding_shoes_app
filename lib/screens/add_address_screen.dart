import 'package:flutter/material.dart';
import 'package:flutter_application_14/constants/app_constants.dart';
import 'package:flutter_application_14/providers/app_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String _addressType = "Home";
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _houseController = TextEditingController();
  final _roadController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _houseController.dispose();
    _roadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor, 
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Add delivery address",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Full Name(Required) *", _nameController),
            const SizedBox(height: 16),
            _buildTextField("Phone number (Required) *", _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 8),
            Text(
              "Make sure to enter correct phone number. Delivery person may call you for directions.",
              style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField("Pincode (Required) *", _pincodeController, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.my_location, size: 18, color: Colors.white),
                  label: Text(
                    "Use my location",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField("State (Required) *", _stateController)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField("City (Required) *", _cityController)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField("House No., Building Name (Required) *", _houseController),
            const SizedBox(height: 16),
            _buildTextField("Road name, Area, Colony (Required) *", _roadController),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16, color: Colors.blue),
              label: Text(
                "Add Nearby Famous Shop/Mall/Landmark",
                style: GoogleFonts.poppins(color: Colors.blue, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Type of address",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTypeChip(context, "Home", Icons.home_filled),
                const SizedBox(width: 12),
                _buildTypeChip(context, "Work", Icons.work),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill required fields")),
                    );
                    return;
                  }

                  provider.addAddress(
                    title: _addressType, 
                    fullName: _nameController.text, 
                    phoneNumber: _phoneController.text, 
                    pincode: _pincodeController.text, 
                    state: _stateController.text, 
                    city: _cityController.text, 
                    houseNo: _houseController.text, 
                    roadName: _roadController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Address Saved Successfully!")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  "Save Address",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context, String label, IconData icon) {
    bool isSelected = _addressType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _addressType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected ? AppConstants.primaryColor : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppConstants.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? AppConstants.primaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
