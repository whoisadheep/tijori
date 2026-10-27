import 'package:flutter/material.dart';
import 'package:tijori/core/licensing/freemium_guard.dart';
import 'package:tijori/core/licensing/license_models.dart';

class KarigarScreen extends StatelessWidget {
  const KarigarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karigar (Artisan) Management'),
      ),
      body: const FreemiumGuard(
        feature: GatedFeature.karigarManagement,
        child: Center(
          child: Text('Karigar Ledger Module (Unlocked)'),
        ),
      ),
    );
  }
}
