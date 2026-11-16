import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/utils/girvi_calculator.dart';
import 'package:tijori/core/utils/gst_calculator.dart';

void main() {
  group('Defensive Input Boundary Tests', () {
    test('calculateNetWeight enforces 0 to 100 purity and non-negative gross weight', () {
      expect(
        () => GirviCalculator.calculateNetWeight(grossWeight: -5.0, purityPercent: 91.6),
        throwsA(anyOf(isA<ArgumentError>(), isA<AssertionError>())),
      );
      expect(
        () => GirviCalculator.calculateNetWeight(grossWeight: 10.0, purityPercent: 120.0),
        throwsA(anyOf(isA<ArgumentError>(), isA<AssertionError>())),
      );
      expect(
        () => GirviCalculator.calculateNetWeight(grossWeight: 10.0, purityPercent: -1.0),
        throwsA(anyOf(isA<ArgumentError>(), isA<AssertionError>())),
      );
    });

    test('calculateDayWiseInterest handles inverted dates gracefully without negative interest', () {
      final interest = GirviCalculator.calculateDayWiseInterest(
        principal: 10000,
        roi: 2.0,
        startDate: DateTime(2025, 2, 1),
        endDate: DateTime(2025, 1, 1), // Inverted date
      );
      expect(interest, equals(0.0));
    });

    test('GstCalculator safely handles negative and extreme tax slabs without division by zero', () {
      final breakdown = GstCalculator.computeTaxFromGross(
        grossTotal: 100000.0,
        taxSlabPercent: -100.0, // Extreme boundary
      );
      expect(breakdown.totalAmount, equals(100000.0));
      expect(breakdown.taxableAmount, equals(100000.0));
    });
  });
}
