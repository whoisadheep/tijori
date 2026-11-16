import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/printing/slip_printer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SlipPrinter PDF generation tests', () {
    final testParty = Party(
      id: 1,
      name: 'Rameshwar Patil',
      groupType: PartyGroupType.customer,
      mobile: '9876543210',
      address: 'Shop 4, Gold Bazaar',
      state: 'Maharashtra',
      kycDocType: 'Aadhaar',
      kycDocNumber: '1234-5678-9012',
      createdAt: DateTime(2025, 1, 1),
    );

    final testLoan = GirviLoan(
      id: 10,
      slipNumber: 'GIRVI-000001',
      partyId: 1,
      transactionDate: DateTime(2025, 1, 10, 11, 30),
      interestStartDate: DateTime(2025, 1, 10),
      roi: 1.5,
      interestType: InterestType.monthWise,
      metalType: MetalType.gold,
      grossWeight: 15.5,
      purityPercent: 91.6,
      netWeight: 14.20,
      estimatedValue: 98000.0,
      principalAmount: 70000.0,
      paymentMode: PaymentMode.cash,
      itemDescription: 'Gold Necklace 22K (Hallmarked)',
      status: LoanStatus.active,
      rackLocation: 'Vault 1 / Box A',
    );

    final testReceipt = LoanReceipt(
      id: 5,
      receiptNumber: 'REC-000001',
      loanId: 10,
      date: DateTime(2025, 2, 10, 15, 0),
      paymentMode: PaymentMode.cash,
      receiptType: ReceiptType.interestOnly,
      amount: 1050.0,
      remarks: 'Interest paid for 1 month',
    );

    test('generates valid non-empty Girvi pledge slip PDF with watermark', () async {
      final pdfBytes = await SlipPrinter.generateGirviSlipPdf(
        loan: testLoan,
        party: testParty,
        shopName: 'Shree Ganesh Jewellers',
        shopPhone: '9822001122',
        shopAddress: 'Main Road, Pune',
        watermarkText: 'Generated via Tijori ERP (Free Trial)',
        isThermal: true,
      );

      expect(pdfBytes, isNotEmpty);
      // PDF standard header "%PDF" in ASCII bytes: 0x25, 0x50, 0x44, 0x46
      expect(pdfBytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });

    test('generates valid non-empty Payment Receipt PDF', () async {
      final pdfBytes = await SlipPrinter.generatePaymentReceiptPdf(
        receipt: testReceipt,
        loan: testLoan,
        party: testParty,
        shopName: 'Shree Ganesh Jewellers',
        watermarkText: null, // Pro edition without watermark
        isThermal: true,
      );

      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });
  });
}
