/// Pure financial engine for Goods and Services Tax (GST) calculations in Tijori ERP.
abstract final class GstCalculator {
  /// Standard GST tax slabs applicable in Indian Jewellery ERP:
  /// - 3.0%: Standard for Gold & Silver Jewellery (HSN 7113) & Bullion (HSN 7108)
  /// - 5.0%: Job-work / Making charges (HSN 9988) or loose gemstones
  /// - 18.0%: Certification, hallmarking fees, banking or professional services
  /// - 0.0%: Exempt transactions, agriculture, or pure bullion transfers
  static const double goldJewellerySlab = 3.0;
  static const double jobWorkSlab = 5.0;
  static const double serviceSlab = 18.0;
  static const double exemptSlab = 0.0;

  /// Computes the CGST, SGST, and Grand Total given a [taxableAmount] and [taxSlabPercent].
  ///
  /// For standard intra-state transactions:
  /// - `cgst = taxableAmount * (taxSlabPercent / 200)`
  /// - `sgst = taxableAmount * (taxSlabPercent / 200)`
  /// - `total = taxableAmount + cgst + sgst`
  static GstBreakdown computeTax({
    required double taxableAmount,
    required double taxSlabPercent,
  }) {
    if (taxableAmount <= 0 || taxSlabPercent <= 0) {
      return GstBreakdown(
        taxableAmount: taxableAmount > 0 ? taxableAmount : 0.0,
        taxSlabPercent: taxSlabPercent > 0 ? taxSlabPercent : 0.0,
        cgstAmount: 0.0,
        sgstAmount: 0.0,
        totalAmount: taxableAmount > 0 ? taxableAmount : 0.0,
      );
    }

    final halfRate = taxSlabPercent / 200.0;
    // Round to 2 decimal places to adhere to standard accounting rounding
    final cgst = double.parse((taxableAmount * halfRate).toStringAsFixed(2));
    final sgst = double.parse((taxableAmount * halfRate).toStringAsFixed(2));
    final total = double.parse((taxableAmount + cgst + sgst).toStringAsFixed(2));

    return GstBreakdown(
      taxableAmount: taxableAmount,
      taxSlabPercent: taxSlabPercent,
      cgstAmount: cgst,
      sgstAmount: sgst,
      totalAmount: total,
    );
  }

  /// Calculates reverse tax breakdown when only the final gross total is known.
  static GstBreakdown computeTaxFromGross({
    required double grossTotal,
    required double taxSlabPercent,
  }) {
    if (grossTotal <= 0) {
      return const GstBreakdown(
        taxableAmount: 0.0,
        taxSlabPercent: 0.0,
        cgstAmount: 0.0,
        sgstAmount: 0.0,
        totalAmount: 0.0,
      );
    }

    final divisor = 1.0 + (taxSlabPercent / 100.0);
    if (divisor <= 0) {
      return GstBreakdown(
        taxableAmount: grossTotal,
        taxSlabPercent: 0.0,
        cgstAmount: 0.0,
        sgstAmount: 0.0,
        totalAmount: grossTotal,
      );
    }
    final taxable = double.parse((grossTotal / divisor).toStringAsFixed(2));
    return computeTax(taxableAmount: taxable, taxSlabPercent: taxSlabPercent);
  }
}

class GstBreakdown {
  final double taxableAmount;
  final double taxSlabPercent;
  final double cgstAmount;
  final double sgstAmount;
  final double totalAmount;

  const GstBreakdown({
    required this.taxableAmount,
    required this.taxSlabPercent,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.totalAmount,
  });

  double get totalTax => cgstAmount + sgstAmount;
}
