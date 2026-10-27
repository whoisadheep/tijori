/// All enums used across the Tijori ERP Drift database schema.
library;

enum PartyGroupType { customer, karigar, supplier }

enum InterestType { dayWise, monthWise }

enum MetalType { gold, silver }

enum PaymentMode { cash, upi, bank, credit }

enum LoanStatus { active, closed, auctioned }

enum ReceiptType { interestOnly, principalRepayment }

enum KarigarTxnType { issue, receive }

enum GstVoucherType {
  sale,
  purchase,
  saleReturn,
  purchaseReturn,
  debitNote,
  creditNote,
  expense,
  income,
}

enum PaymentTerm { cash, credit }
