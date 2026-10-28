import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/utils/gst_calculator.dart';

void main() {
  group('GstCalculator Engine Tests', () {
    test('accurately computes 3% GST on 100,000 gold jewellery sale', () {
      final breakdown = GstCalculator.computeTax(
        taxableAmount: 100000.0,
        taxSlabPercent: 3.0,
      );

      // 1.5% CGST = 1500, 1.5% SGST = 1500, Total = 103000
      expect(breakdown.cgstAmount, 1500.0);
      expect(breakdown.sgstAmount, 1500.0);
      expect(breakdown.totalTax, 3000.0);
      expect(breakdown.totalAmount, 103000.0);
    });

    test('handles 0% exempt transaction properly', () {
      final breakdown = GstCalculator.computeTax(
        taxableAmount: 50000.0,
        taxSlabPercent: 0.0,
      );

      expect(breakdown.cgstAmount, 0.0);
      expect(breakdown.sgstAmount, 0.0);
      expect(breakdown.totalTax, 0.0);
      expect(breakdown.totalAmount, 50000.0);
    });

    test('reverse computes tax from gross invoice total', () {
      // 103,000 inclusive of 3% tax
      final breakdown = GstCalculator.computeTaxFromGross(
        grossTotal: 103000.0,
        taxSlabPercent: 3.0,
      );

      expect(breakdown.taxableAmount, closeTo(100000.0, 0.5));
      expect(breakdown.totalAmount, closeTo(103000.0, 0.5));
    });
  });
}
