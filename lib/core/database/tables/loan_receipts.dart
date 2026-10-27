import 'package:drift/drift.dart';

import 'enums.dart';
import 'girvi_loans.dart';

/// Receipts (interest or principal repayment) against a Girvi loan.
class LoanReceipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get receiptNumber => text().unique()();
  IntColumn get loanId => integer().references(GirviLoans, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get paymentMode => textEnum<PaymentMode>()();
  TextColumn get receiptType => textEnum<ReceiptType>()();
  RealColumn get amount => real()();
  TextColumn get remarks => text().nullable()();
}
