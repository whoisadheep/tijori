import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/gst_vouchers.dart';
import '../tables/parties.dart';

part 'gst_vouchers_dao.g.dart';

@DriftAccessor(tables: [GstVouchers, Parties])
class GstVouchersDao extends DatabaseAccessor<AppDatabase>
    with _$GstVouchersDaoMixin {
  GstVouchersDao(super.db);

  /// Watches all GST vouchers, ordered by date descending.
  Stream<List<GstVoucher>> watchAllVouchers() {
    return (select(gstVouchers)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Watches vouchers filtered by [type], ordered by date descending.
  Stream<List<GstVoucher>> watchVouchersByType(GstVoucherType type) {
    return (select(gstVouchers)
          ..where((t) => t.voucherType.equalsValue(type))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Inserts a new voucher and returns the generated row id.
  Future<int> insertVoucher(GstVouchersCompanion voucher) {
    return into(gstVouchers).insert(voucher);
  }

  /// Generates the next bill number for the given voucher [type].
  ///
  /// Format uses an uppercase prefix derived from the enum name:
  /// - `sale`           → `"SALE-000001"`
  /// - `purchase`       → `"PURCHASE-000001"`
  /// - `saleReturn`     → `"SALERETURN-000001"`
  /// - `purchaseReturn` → `"PURCHASERETURN-000001"`
  /// - `debitNote`      → `"DEBITNOTE-000001"`
  /// - `creditNote`     → `"CREDITNOTE-000001"`
  /// - `expense`        → `"EXPENSE-000001"`
  /// - `income`         → `"INCOME-000001"`
  Future<String> generateNextBillNumber(GstVoucherType type) async {
    final countExp = gstVouchers.id.count();
    final query = selectOnly(gstVouchers)
      ..addColumns([countExp])
      ..where(gstVouchers.voucherType.equalsValue(type));
    final row = await query.getSingle();
    final currentCount = row.read(countExp) ?? 0;
    final nextNumber = currentCount + 1;
    final prefix = type.name.toUpperCase();
    return '$prefix-${nextNumber.toString().padLeft(6, '0')}';
  }
}
