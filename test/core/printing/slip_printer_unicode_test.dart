import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/printing/slip_printer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SlipPrinter Unicode & Thermal Format Assertions', () {
    final devanagariParty = Party(
      id: 1,
      name: 'श्री रमेश पोतदार (Ramesh Potdar)',
      groupType: PartyGroupType.customer,
      mobile: '9822001122',
      address: 'रविवार पेठ, पुणे, महाराष्ट्र',
      createdAt: DateTime.now(),
    );

    final regionalLoan = GirviLoan(
      id: 1,
      slipNumber: 'GIRVI-000100',
      partyId: 1,
      transactionDate: DateTime.now(),
      interestStartDate: DateTime.now(),
      roi: 1.5,
      interestType: InterestType.monthWise,
      metalType: MetalType.gold,
      grossWeight: 25.50,
      purityPercent: 91.6,
      netWeight: 23.35,
      estimatedValue: 175000.0,
      principalAmount: 120000.0,
      paymentMode: PaymentMode.cash,
      itemDescription: 'पारंपारिक कोल्हापुरी साज व २ तोडे (22K Hallmarked)',
      status: LoanStatus.active,
    );

    test('generates valid PDF without crashing on Devanagari text and Rupee symbol', () async {
      final pdfBytes = await SlipPrinter.generateGirviSlipPdf(
        loan: regionalLoan,
        party: devanagariParty,
        shopName: 'श्री महालक्ष्मी ज्वेलर्स',
        shopAddress: 'सराफ बाजार, पुणे',
        watermarkText: null,
        isThermal: true,
      );

      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });

    test('thermal slip generates within finite roll printable boundary without layout overflow', () async {
      final pdfBytes = await SlipPrinter.generateGirviSlipPdf(
        loan: regionalLoan.copyWith(
          itemDescription: 'A' * 250, // Long description stress-test
        ),
        party: devanagariParty,
        isThermal: true,
      );

      expect(pdfBytes, isNotEmpty);
    });
  });
}
