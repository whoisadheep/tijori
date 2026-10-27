import 'package:flutter/material.dart';
import 'package:tijori/core/licensing/freemium_guard.dart';
import 'package:tijori/core/licensing/license_models.dart';

class GstScreen extends StatelessWidget {
  const GstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GST Invoicing & Vouchers'),
      ),
      body: const FreemiumGuard(
        feature: GatedFeature.gstVouchers,
        child: Center(
          child: Text('GST Accounting Vouchers (Unlocked)'),
        ),
      ),
    );
  }
}
