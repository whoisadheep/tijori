/// Represents the jeweller's shop details printed on thermal receipts,
/// pledge slips, payment vouchers, and GST tax invoices.
class ShopProfile {
  final String shopName;
  final String? tagline;
  final String? address;
  final String? phone;
  final String? email;
  final String? gstin;
  final String? licenseNumber;
  final String? termsAndConditions;

  const ShopProfile({
    this.shopName = 'Tijori Jewellers',
    this.tagline = 'Gold, Silver & Diamond Ornaments',
    this.address,
    this.phone,
    this.email,
    this.gstin,
    this.licenseNumber,
    this.termsAndConditions =
        '1. All loans subject to local jurisdiction.\n'
        '2. Pledged ornaments can be redeemed upon presentation of original slip.\n'
        '3. Interest charged on complete or partial month basis as per agreed terms.',
  });

  Map<String, dynamic> toJson() => {
        'shop_name': shopName,
        'tagline': tagline,
        'address': address,
        'phone': phone,
        'email': email,
        'gstin': gstin,
        'license_number': licenseNumber,
        'terms_and_conditions': termsAndConditions,
      };

  factory ShopProfile.fromJson(Map<String, dynamic> json) => ShopProfile(
        shopName: json['shop_name'] as String? ?? 'Tijori Jewellers',
        tagline: json['tagline'] as String?,
        address: json['address'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        gstin: json['gstin'] as String?,
        licenseNumber: json['license_number'] as String?,
        termsAndConditions: json['terms_and_conditions'] as String?,
      );

  ShopProfile copyWith({
    String? shopName,
    String? tagline,
    String? address,
    String? phone,
    String? email,
    String? gstin,
    String? licenseNumber,
    String? termsAndConditions,
  }) {
    return ShopProfile(
      shopName: shopName ?? this.shopName,
      tagline: tagline ?? this.tagline,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
    );
  }
}
