class Address {
  final String id;
  final String title; // Home/Work
  final String fullName;
  final String phoneNumber;
  final String pincode;
  final String state;
  final String city;
  final String houseNo;
  final String roadName;
  final bool isDefault;

  Address({
    required this.id,
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.pincode,
    required this.state,
    required this.city,
    required this.houseNo,
    required this.roadName,
    this.isDefault = false,
  });

  String get addressLine => "$houseNo, $roadName, $city, $state - $pincode";
}
