import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/shop_profile_model.dart';

export '../data/shop_profile_model.dart';

/// Riverpod Notifier managing persistent local Shop Profile details
/// used across thermal print slips, payment receipts, and GST invoices.
class ShopProfileNotifier extends Notifier<ShopProfile> {
  static const String _prefsKey = 'tijori_shop_profile_v1';

  @override
  ShopProfile build() {
    _loadFromPrefs();
    return const ShopProfile();
  }

  /// Loads cached shop details from SharedPreferences.
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final Map<String, dynamic> map =
            jsonDecode(raw) as Map<String, dynamic>;
        state = ShopProfile.fromJson(map);
      }
    } catch (e) {
      debugPrint('[ShopProfile] Error reading from SharedPreferences: $e');
    }
  }

  /// Saves updated shop profile to local persistent storage.
  Future<void> updateProfile(ShopProfile updated) async {
    state = updated;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(updated.toJson()));
    } catch (e) {
      debugPrint('[ShopProfile] Error saving to SharedPreferences: $e');
    }
  }
}

/// Global provider for accessing and modifying the jeweller's shop details.
final shopProfileProvider =
    NotifierProvider<ShopProfileNotifier, ShopProfile>(ShopProfileNotifier.new);
