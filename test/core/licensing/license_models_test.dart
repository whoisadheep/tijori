import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/licensing/license_models.dart';

void main() {
  group('LicenseState & Freemium Logic', () {
    test('default free license provides free tier features only', () {
      final license = LicenseState.defaultFree();
      expect(license.effectiveTier, equals(SubscriptionTier.free));
      expect(license.effectiveTier.isPaid, isFalse);
    });

    test('active pro license provides pro tier features', () {
      final license = LicenseState(
        tier: SubscriptionTier.pro,
        isActive: true,
        remoteKillSwitch: false,
        lastVerifiedAt: DateTime.now(),
        validUntil: DateTime.now().add(const Duration(days: 30)),
      );
      expect(license.effectiveTier, equals(SubscriptionTier.pro));
    });

    test('kill-switch or inactive immediately reverts tier to Free', () {
      final licenseKilled = LicenseState(
        tier: SubscriptionTier.enterprise,
        isActive: true,
        remoteKillSwitch: true, // Kill switch active
        lastVerifiedAt: DateTime.now(),
      );
      expect(licenseKilled.effectiveTier, equals(SubscriptionTier.free));

      final licenseInactive = LicenseState(
        tier: SubscriptionTier.enterprise,
        isActive: false, // Inactive
        remoteKillSwitch: false,
        lastVerifiedAt: DateTime.now(),
      );
      expect(licenseInactive.effectiveTier, equals(SubscriptionTier.free));
    });

    test('expired subscription reverts tier to Free', () {
      final expiredLicense = LicenseState(
        tier: SubscriptionTier.pro,
        isActive: true,
        remoteKillSwitch: false,
        lastVerifiedAt: DateTime.now(),
        validUntil: DateTime.now().subtract(const Duration(days: 1)), // Expired
      );
      expect(expiredLicense.isSubscriptionExpired, isTrue);
      expect(expiredLicense.effectiveTier, equals(SubscriptionTier.free));
    });

    test('offline grace period expiry reverts to Free after 7 days', () {
      final validWithin7Days = LicenseState(
        tier: SubscriptionTier.pro,
        isActive: true,
        remoteKillSwitch: false,
        lastVerifiedAt: DateTime.now().subtract(const Duration(days: 5)),
        validUntil: DateTime.now().add(const Duration(days: 30)),
      );
      expect(validWithin7Days.isOfflineGraceExpired(graceDays: 7), isFalse);
      expect(validWithin7Days.effectiveTier, equals(SubscriptionTier.pro));

      final expiredAfter7Days = LicenseState(
        tier: SubscriptionTier.pro,
        isActive: true,
        remoteKillSwitch: false,
        lastVerifiedAt: DateTime.now().subtract(const Duration(days: 8)),
        validUntil: DateTime.now().add(const Duration(days: 30)),
      );
      expect(expiredAfter7Days.isOfflineGraceExpired(graceDays: 7), isTrue);
      expect(expiredAfter7Days.effectiveTier, equals(SubscriptionTier.free));
    });

    test('serialization and deserialization roundtrip preserves license state', () {
      final original = LicenseState(
        tier: SubscriptionTier.enterprise,
        validUntil: DateTime(2027, 1, 1),
        isActive: true,
        remoteKillSwitch: false,
        lastVerifiedAt: DateTime(2025, 5, 1, 10, 0),
        shopName: 'Shree Krishna Jewellers',
        ownerEmail: 'owner@shreekrishna.com',
      );

      final serialized = original.serialize();
      final restored = LicenseState.deserialize(serialized);

      expect(restored, isNotNull);
      expect(restored!.tier, equals(original.tier));
      expect(restored.shopName, equals(original.shopName));
      expect(restored.ownerEmail, equals(original.ownerEmail));
      expect(restored.isActive, equals(original.isActive));
      expect(restored.remoteKillSwitch, equals(original.remoteKillSwitch));
    });
  });
}
