import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/features/settings/data/shop_profile_model.dart';

void main() {
  group('ShopProfile Model Tests', () {
    test('default ShopProfile provides default Tijori branding', () {
      const profile = ShopProfile();
      expect(profile.shopName, equals('Tijori Jewellers'));
      expect(profile.tagline, contains('Gold, Silver'));
      expect(profile.termsAndConditions, isNotNull);
      expect(profile.phone, isNull);
      expect(profile.gstin, isNull);
    });

    test('serializes and deserializes cleanly through JSON', () {
      const original = ShopProfile(
        shopName: 'Shree Krishna Jewellers',
        tagline: '916 Hallmark Jewellery',
        address: '101 Sarafa Bazar, Pune - 411002',
        phone: '+91 98765 43210',
        email: 'info@shreekrishna.com',
        gstin: '27AAAPL1234C1ZV',
        licenseNumber: 'LIC/MH/PUN/2024/098',
        termsAndConditions: 'All loans subject to Pune jurisdiction.',
      );

      final json = original.toJson();
      final restored = ShopProfile.fromJson(json);

      expect(restored.shopName, equals('Shree Krishna Jewellers'));
      expect(restored.tagline, equals('916 Hallmark Jewellery'));
      expect(restored.address, equals('101 Sarafa Bazar, Pune - 411002'));
      expect(restored.phone, equals('+91 98765 43210'));
      expect(restored.email, equals('info@shreekrishna.com'));
      expect(restored.gstin, equals('27AAAPL1234C1ZV'));
      expect(restored.licenseNumber, equals('LIC/MH/PUN/2024/098'));
      expect(restored.termsAndConditions, equals('All loans subject to Pune jurisdiction.'));
    });

    test('copyWith properly overrides specific fields while keeping others', () {
      const base = ShopProfile(
        shopName: 'Laxmi Jewellers',
        phone: '1234567890',
      );

      final updated = base.copyWith(
        shopName: 'Maha Laxmi Jewellers',
        address: 'Main Chowk, Nashik',
      );

      expect(updated.shopName, equals('Maha Laxmi Jewellers'));
      expect(updated.phone, equals('1234567890'));
      expect(updated.address, equals('Main Chowk, Nashik'));
    });
  });
}
