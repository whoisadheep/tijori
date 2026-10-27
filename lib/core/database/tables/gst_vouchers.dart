import 'package:drift/drift.dart';

import 'enums.dart';
import 'parties.dart';

/// GST-compliant vouchers — sales, purchases, returns, notes, expenses, income.
class GstVouchers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get voucherType => textEnum<GstVoucherType>()();
  TextColumn get paymentTerm => textEnum<PaymentTerm>()();
  IntColumn get partyId => integer().references(Parties, #id)();
  TextColumn get bookSeries => text().nullable()();
  TextColumn get billNumber => text().unique()();
  DateTimeColumn get date => dateTime()();
  TextColumn get hsnCode => text().nullable()();
  TextColumn get description => text()();
  RealColumn get taxSlabPercent => real()();
  RealColumn get taxableAmount => real()();
  RealColumn get cgstAmount => real()();
  RealColumn get sgstAmount => real()();
  RealColumn get totalAmount => real()();
}
