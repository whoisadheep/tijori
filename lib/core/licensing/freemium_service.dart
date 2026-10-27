import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_constants.dart';
import '../database/app_database.dart';
import 'license_models.dart';

export 'license_models.dart';

/// Riverpod Notifier managing online/offline licensing and feature gating.
class FreemiumNotifier extends Notifier<LicenseState> {
  static const String _storageKey = 'tijori_license_payload_v1';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock),
    wOptions: WindowsOptions(useBackwardCompatibility: false),
    lOptions: LinuxOptions(),
  );

  @override
  LicenseState build() {
    // Start with default Free tier immediately to remain non-blocking/synchronous
    _initializeLicense();
    return LicenseState.defaultFree();
  }

  /// Loads cached state from secure storage and attempts a background remote refresh.
  Future<void> _initializeLicense() async {
    try {
      final cachedRaw = await _secureStorage.read(key: _storageKey);
      if (cachedRaw != null) {
        final cached = LicenseState.deserialize(cachedRaw);
        if (cached != null) {
          state = cached;
        }
      }
    } catch (e) {
      debugPrint('[Freemium] Error reading secure storage cache: $e');
    }

    // Attempt background sync if online & Supabase configured
    await refreshLicenseSilently();
  }

  /// Checks if a given feature is accessible under the current effective tier.
  bool isFeatureAvailable(GatedFeature feature) {
    return state.effectiveTier.index >= feature.requiredTier.index;
  }

  /// Checks whether the user has hit the Free-tier active loan limit (25 loans).
  Future<bool> hasReachedFreeLoanLimit() async {
    if (state.effectiveTier.isPaid) {
      return false;
    }
    try {
      final activeCount =
          await ref.read(girviLoansDaoProvider).countActiveLoans();
      return activeCount >= AppConstants.freeMaxActiveLoans;
    } catch (e) {
      debugPrint('[Freemium] Error checking active loan count: $e');
      return false;
    }
  }

  /// Returns the watermark text required on generated PDFs/slips.
  /// Returns `null` if the user is on Pro or Enterprise tier.
  String? getPdfWatermark() {
    if (state.effectiveTier.isPaid) return null;
    return 'Generated via Tijori ERP (Free Trial)';
  }

  /// Synchronizes license status against the remote Supabase control plane.
  /// Falls back gracefully to offline cached state if unreachable.
  Future<bool> refreshLicenseSilently() async {
    try {
      // 1. Verify Supabase initialization and active session
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        // No authenticated session — stay with cached or default state
        return false;
      }

      // 2. Query remote lightweight `shop_licenses` table
      final response = await supabase
          .from('shop_licenses')
          .select('tier, valid_until, is_active, remote_kill_switch, shop_name')
          .eq('user_id', currentUser.id)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));

      if (response != null) {
        final updated = LicenseState(
          tier: SubscriptionTier.fromString(response['tier'] as String?),
          validUntil: response['valid_until'] != null
              ? DateTime.tryParse(response['valid_until'] as String)
              : null,
          isActive: (response['is_active'] as bool?) ?? true,
          remoteKillSwitch:
              (response['remote_kill_switch'] as bool?) ?? false,
          lastVerifiedAt: DateTime.now(),
          shopName: response['shop_name'] as String?,
          ownerEmail: currentUser.email,
        );

        // 3. Cache the verified state into encrypted storage
        await _secureStorage.write(
          key: _storageKey,
          value: updated.serialize(),
        );

        state = updated;
        return true;
      }
    } catch (e) {
      debugPrint(
        '[Freemium] Remote check-in skipped or unavailable (offline): $e',
      );
    }
    return false;
  }

  /// Manually activate an offline license key or update cached tier.
  Future<void> updateOfflineLicense(LicenseState newState) async {
    await _secureStorage.write(
      key: _storageKey,
      value: newState.serialize(),
    );
    state = newState;
  }
}

/// Singleton Riverpod provider for the Freemium Licensing Service.
final freemiumProvider =
    NotifierProvider<FreemiumNotifier, LicenseState>(FreemiumNotifier.new);

/// Convenience provider to query feature availability reactively.
final isFeatureAvailableProvider =
    Provider.family<bool, GatedFeature>((ref, feature) {
  final license = ref.watch(freemiumProvider);
  return license.effectiveTier.index >= feature.requiredTier.index;
});

/// Convenience provider to check active loan limit status.
final hasReachedLoanLimitProvider = FutureProvider<bool>((ref) async {
  final notifier = ref.read(freemiumProvider.notifier);
  return notifier.hasReachedFreeLoanLimit();
});
