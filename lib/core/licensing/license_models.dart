import 'dart:convert';

/// Subscription tiers for Tijori ERP.
enum SubscriptionTier {
  free('Free'),
  pro('Pro'),
  enterprise('Enterprise');

  final String displayName;
  const SubscriptionTier(this.displayName);

  static SubscriptionTier fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'pro' => SubscriptionTier.pro,
      'enterprise' => SubscriptionTier.enterprise,
      _ => SubscriptionTier.free,
    };
  }

  bool get isPaid => this != SubscriptionTier.free;
}

/// System features subject to tier restrictions.
enum GatedFeature {
  girviLoans(
    'Girvi Loan Management',
    'Core pawn and loan tracking. Free tier is limited to 25 active loans.',
    SubscriptionTier.free,
  ),
  karigarManagement(
    'Karigar (Artisan) Management',
    'Track gold/silver issues, receipts, losses, and artisan ledgers.',
    SubscriptionTier.pro,
  ),
  gstVouchers(
    'GST Invoicing & Vouchers',
    'Generate compliant B2B/B2C invoices, purchase vouchers, and credit notes.',
    SubscriptionTier.pro,
  ),
  advancedReports(
    'Advanced Analytics & Audit Logs',
    'In-depth profit/loss, daily metal balance, and compliance audit exports.',
    SubscriptionTier.enterprise,
  ),
  bulkPrinting(
    'Batch Thermal & Barcode Slip Printing',
    'One-click printing for day-end loan receipts and inventory labels.',
    SubscriptionTier.pro,
  ),
  dataExport(
    'Excel / CSV & Tally XML Export',
    'Export ledgers and vouchers directly into external accounting packages.',
    SubscriptionTier.pro,
  );

  final String title;
  final String description;
  final SubscriptionTier requiredTier;

  const GatedFeature(this.title, this.description, this.requiredTier);
}

/// Represents the cached or freshly verified licensing state.
class LicenseState {
  final SubscriptionTier tier;
  final DateTime? validUntil;
  final bool isActive;
  final bool remoteKillSwitch;
  final DateTime lastVerifiedAt;
  final String? shopName;
  final String? ownerEmail;

  const LicenseState({
    required this.tier,
    this.validUntil,
    this.isActive = true,
    this.remoteKillSwitch = false,
    required this.lastVerifiedAt,
    this.shopName,
    this.ownerEmail,
  });

  /// Factory creating the default offline Free Tier license.
  factory LicenseState.defaultFree() {
    return LicenseState(
      tier: SubscriptionTier.free,
      isActive: true,
      remoteKillSwitch: false,
      lastVerifiedAt: DateTime.now(),
    );
  }

  /// Whether the offline grace period (7 days) has expired without a check-in.
  bool isOfflineGraceExpired({int graceDays = 7}) {
    final expiry = lastVerifiedAt.add(Duration(days: graceDays));
    return DateTime.now().isAfter(expiry);
  }

  /// Whether the license subscription has expired according to [validUntil].
  bool get isSubscriptionExpired {
    if (validUntil == null) return false;
    return DateTime.now().isAfter(validUntil!);
  }

  /// The effective tier factoring in kill-switch, status, and expiry.
  SubscriptionTier get effectiveTier {
    if (remoteKillSwitch || !isActive) {
      return SubscriptionTier.free;
    }
    if (tier.isPaid && isSubscriptionExpired) {
      return SubscriptionTier.free;
    }
    if (tier.isPaid && isOfflineGraceExpired()) {
      return SubscriptionTier.free;
    }
    return tier;
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'valid_until': validUntil?.toIso8601String(),
      'is_active': isActive,
      'remote_kill_switch': remoteKillSwitch,
      'last_verified_at': lastVerifiedAt.toIso8601String(),
      'shop_name': shopName,
      'owner_email': ownerEmail,
    };
  }

  factory LicenseState.fromJson(Map<String, dynamic> json) {
    return LicenseState(
      tier: SubscriptionTier.fromString(json['tier'] as String?),
      validUntil: json['valid_until'] != null
          ? DateTime.tryParse(json['valid_until'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      remoteKillSwitch: json['remote_kill_switch'] as bool? ?? false,
      lastVerifiedAt: json['last_verified_at'] != null
          ? DateTime.tryParse(json['last_verified_at'] as String) ??
              DateTime.now()
          : DateTime.now(),
      shopName: json['shop_name'] as String?,
      ownerEmail: json['owner_email'] as String?,
    );
  }

  String serialize() => jsonEncode(toJson());

  static LicenseState? deserialize(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return LicenseState.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  LicenseState copyWith({
    SubscriptionTier? tier,
    DateTime? validUntil,
    bool? isActive,
    bool? remoteKillSwitch,
    DateTime? lastVerifiedAt,
    String? shopName,
    String? ownerEmail,
  }) {
    return LicenseState(
      tier: tier ?? this.tier,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
      remoteKillSwitch: remoteKillSwitch ?? this.remoteKillSwitch,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      shopName: shopName ?? this.shopName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
    );
  }
}
