import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tijori/core/database/app_database.dart';
import 'package:tijori/core/utils/photo_storage_helper.dart';

/// Thermal and A4 slip printing engine for Tijori Jewellery ERP.
abstract final class SlipPrinter {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: 'Rs. ',
    decimalDigits: 2,
  );
  static final _dateFormat = DateFormat('dd-MMM-yyyy');
  static final _dateTimeFormat = DateFormat('dd-MMM-yyyy hh:mm a');

  static Future<pw.Document> _createDocument() async {
    try {
      final font = await PdfGoogleFonts.notoSansRegular();
      final fontBold = await PdfGoogleFonts.notoSansBold();
      return pw.Document(
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
      );
    } catch (_) {
      return pw.Document();
    }
  }

  /// Generates a PDF byte stream for a Girvi Loan Pledge slip.
  static Future<Uint8List> generateGirviSlipPdf({
    required GirviLoan loan,
    required Party party,
    String? shopName,
    String? shopPhone,
    String? shopAddress,
    String? termsAndConditions,
    String? watermarkText,
    bool isThermal = true,
  }) async {
    final pdf = await _createDocument();
    final format = isThermal
        ? const PdfPageFormat(
            72 * PdfPageFormat.mm,
            200 * PdfPageFormat.mm,
            marginAll: 4 * PdfPageFormat.mm,
          )
        : PdfPageFormat.a5;

    final photoBytes = PhotoStorageHelper.readPhotoBytes(loan.localPhotoPath);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  (shopName ?? 'TIJORI JEWELLERS').toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: isThermal ? 13 : 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              if (shopAddress != null && shopAddress.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    shopAddress,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              if (shopPhone != null && shopPhone.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    'Tel: $shopPhone',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 0.5),
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                  child: pw.Text(
                    'GIRVI PAWN / PLEDGE SLIP',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Divider(thickness: 0.5),

              // Slip No & Date
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Slip: ${loan.slipNumber}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    _dateFormat.format(loan.transactionDate),
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),

              // Borrower Details
              pw.Container(
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Borrower: ${party.name}',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (party.mobile != null && party.mobile!.isNotEmpty)
                      pw.Text(
                        'Mobile: ${party.mobile}',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    if (party.address != null && party.address!.isNotEmpty)
                      pw.Text(
                        'Address: ${party.address}',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),

              // Article Specs Table
              pw.Text(
                'PLEDGED ARTICLE DETAILS',
                style: const pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _th('Metal'),
                      _th('Gross (g)'),
                      _th('Purity'),
                      _th('Net (g)'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _td(loan.metalType.name.toUpperCase()),
                      _td('${loan.grossWeight.toStringAsFixed(2)}g'),
                      _td('${loan.purityPercent.toStringAsFixed(1)}%'),
                      _td('${loan.netWeight.toStringAsFixed(2)}g'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Description: ${loan.itemDescription}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                        if (loan.rackLocation != null && loan.rackLocation!.isNotEmpty)
                          pw.Text(
                            'Vault / Rack: ${loan.rackLocation}',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                      ],
                    ),
                  ),
                  if (photoBytes != null) ...[
                    pw.SizedBox(width: 6),
                    pw.Container(
                      width: 44,
                      height: 44,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                      ),
                      child: pw.Image(
                        pw.MemoryImage(photoBytes),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Divider(thickness: 0.5),

              // Financial Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Principal Amount:',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    _currencyFormat.format(loan.principalAmount),
                    style: const pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Interest Rate (ROI):', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                    '${loan.roi}% / month (${loan.interestType.name})',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Estimated Valuation:', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                    _currencyFormat.format(loan.estimatedValue),
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Payment Mode:', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                    loan.paymentMode.name.toUpperCase(),
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // Barcode
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: loan.slipNumber,
                  width: 120,
                  height: 28,
                  drawText: false,
                ),
              ),
              pw.SizedBox(height: 8),

              // Signatures
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 80,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: PdfColors.black, width: 0.5),
                          ),
                        ),
                      ),
                      pw.Text(
                        'Borrower Signature',
                        style: const pw.TextStyle(fontSize: 7),
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 80,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: PdfColors.black, width: 0.5),
                          ),
                        ),
                      ),
                      pw.Text(
                        'Authorized Signatory',
                        style: const pw.TextStyle(fontSize: 7),
                      ),
                    ],
                  ),
                ],
              ),
              // Terms & Conditions Footer
              if (termsAndConditions != null && termsAndConditions.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  termsAndConditions,
                  style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey700),
                  textAlign: pw.TextAlign.center,
                ),
              ],
              pw.SizedBox(height: 10),

              // Free trial Watermark if applicable
              if (watermarkText != null) ...[
                pw.Divider(thickness: 0.5),
                pw.Center(
                  child: pw.Text(
                    watermarkText.toUpperCase(),
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generates a PDF byte stream for a Loan Payment receipt.
  static Future<Uint8List> generatePaymentReceiptPdf({
    required LoanReceipt receipt,
    required GirviLoan loan,
    required Party party,
    String? shopName,
    String? shopAddress,
    String? shopPhone,
    String? watermarkText,
    bool isThermal = true,
  }) async {
    final pdf = await _createDocument();
    final format = isThermal
        ? const PdfPageFormat(
            72 * PdfPageFormat.mm,
            200 * PdfPageFormat.mm,
            marginAll: 4 * PdfPageFormat.mm,
          )
        : PdfPageFormat.a5;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          final isInterest = receipt.receiptType == ReceiptType.interestOnly;

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Center(
                child: pw.Text(
                  (shopName ?? 'TIJORI JEWELLERS').toUpperCase(),
                  style: const pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              if (shopAddress != null && shopAddress.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    shopAddress,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              if (shopPhone != null && shopPhone.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    'Tel: $shopPhone',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'PAYMENT ACKNOWLEDGEMENT RECEIPT',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Receipt: ${receipt.receiptNumber}',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    _dateTimeFormat.format(receipt.date),
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
              pw.Text(
                'Against Loan: ${loan.slipNumber}',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.Text(
                'Customer: ${party.name}',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          isInterest ? 'INTEREST RECEIVED:' : 'PRINCIPAL REPAID:',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          _currencyFormat.format(receipt.amount),
                          style: const pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Payment Mode:', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(
                          receipt.paymentMode.name.toUpperCase(),
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    if (receipt.remarks != null && receipt.remarks!.isNotEmpty)
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          'Note: ${receipt.remarks}',
                          style: const pw.TextStyle(fontSize: 7),
                        ),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: receipt.receiptNumber,
                  width: 100,
                  height: 22,
                  drawText: false,
                ),
              ),
              if (watermarkText != null) ...[
                pw.SizedBox(height: 6),
                pw.Center(
                  child: pw.Text(
                    watermarkText,
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generates a PDF byte stream for a Karigar (Goldsmith) Metal Hisaab statement.
  static Future<Uint8List> generateKarigarHisaabPdf({
    required Party karigar,
    required List<KarigarTransaction> transactions,
    required double totalIssuedPure,
    required double totalReceivedPure,
    required double pendingPureBalance,
    String? shopName,
    String? shopAddress,
    String? shopPhone,
    String? watermarkText,
    bool isThermal = true,
  }) async {
    final pdf = await _createDocument();
    final format = isThermal
        ? const PdfPageFormat(
            72 * PdfPageFormat.mm,
            250 * PdfPageFormat.mm,
            marginAll: 4 * PdfPageFormat.mm,
          )
        : PdfPageFormat.a4;

    final dateFmt = DateFormat('dd MMM yyyy');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  (shopName ?? 'TIJORI JEWELLERS').toUpperCase(),
                  style: const pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              if (shopAddress != null && shopAddress.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    shopAddress,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              if (shopPhone != null && shopPhone.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    'Tel: $shopPhone',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  'KARIGAR METAL HISAAB STATEMENT',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.brown900,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Date: ${dateFmt.format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ),
              pw.Divider(thickness: 0.5),

              // Karigar Info
              pw.Text(
                'Artisan: ${karigar.name}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (karigar.mobile != null && karigar.mobile!.isNotEmpty)
                pw.Text('Mobile: ${karigar.mobile}', style: const pw.TextStyle(fontSize: 8)),
              if (karigar.address != null && karigar.address!.isNotEmpty)
                pw.Text('Address: ${karigar.address}', style: const pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 6),

              // Metal Balance Summary Box
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total Pure Gold Issued:', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('${totalIssuedPure.toStringAsFixed(3)} g', style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total Pure Gold Received:', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('${totalReceivedPure.toStringAsFixed(3)} g', style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Divider(thickness: 0.5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'NET BALANCE OUTSTANDING:',
                          style: const pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          '${pendingPureBalance.toStringAsFixed(3)} g',
                          style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        pendingPureBalance > 0
                            ? '(Artisan holds shop pure metal)'
                            : (pendingPureBalance < 0
                                ? '(Shop owes pure metal to artisan)'
                                : '(Account Settled 0.000g)'),
                        style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // Vouchers Table
              pw.Text('RECENT JOB VOUCHERS', style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _th('Voucher'),
                      _th('Type'),
                      _th('Item'),
                      _th('Gross (g)'),
                      _th('Touch'),
                      _th('Pure (g)'),
                    ],
                  ),
                  ...transactions.take(15).map((t) {
                    final isIssue = t.type == KarigarTxnType.issue;
                    return pw.TableRow(
                      children: [
                        _td(t.voucherNumber),
                        _td(isIssue ? 'ISSUE' : 'RCVD'),
                        _td(t.itemDescription),
                        _td('${t.grossWeight.toStringAsFixed(2)}g'),
                        _td('${t.purityPercent.toStringAsFixed(1)}%'),
                        _td('${t.netWeight.toStringAsFixed(3)}g'),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 14),

              // Signatures
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 80,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                        ),
                      ),
                      pw.Text('Karigar Signature', style: const pw.TextStyle(fontSize: 7)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 80,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                        ),
                      ),
                      pw.Text('Authorized Signatory', style: const pw.TextStyle(fontSize: 7)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Watermark
              if (watermarkText != null) ...[
                pw.Divider(thickness: 0.5),
                pw.Center(
                  child: pw.Text(
                    watermarkText.toUpperCase(),
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generates a PDF byte stream for a GST Tax Invoice or Accounting Voucher.
  static Future<Uint8List> generateGstInvoicePdf({
    required GstVoucher voucher,
    required Party party,
    String? shopName,
    String? shopAddress,
    String? shopPhone,
    String? shopGstin,
    String? watermarkText,
    bool isThermal = true,
  }) async {
    final pdf = await _createDocument();
    final format = isThermal
        ? const PdfPageFormat(
            72 * PdfPageFormat.mm,
            250 * PdfPageFormat.mm,
            marginAll: 4 * PdfPageFormat.mm,
          )
        : PdfPageFormat.a4;

    final dateFmt = DateFormat('dd MMM yyyy');
    final isSale = voucher.voucherType == GstVoucherType.sale;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  (shopName ?? 'TIJORI JEWELLERS').toUpperCase(),
                  style: const pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              if (shopAddress != null && shopAddress.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    shopAddress,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              if (shopGstin != null && shopGstin.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    'GSTIN: $shopGstin',
                    style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              pw.SizedBox(height: 3),
              pw.Center(
                child: pw.Text(
                  isSale ? 'GST TAX INVOICE' : '${voucher.voucherType.name.toUpperCase()} VOUCHER',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.brown900,
                  ),
                ),
              ),
              pw.Divider(thickness: 0.5),

              // Invoice & Customer Info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice #: ${voucher.billNumber}', style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Date: ${dateFmt.format(voucher.date)}', style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Customer: ${party.name}', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text('Term: ${voucher.paymentTerm.name.toUpperCase()}', style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
              if (party.mobile != null && party.mobile!.isNotEmpty)
                pw.Text('Mobile: ${party.mobile}', style: const pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 6),

              // Items Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _th('Description'),
                      _th('HSN'),
                      _th('Taxable'),
                      _th('GST %'),
                      _th('Total'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _td(voucher.description),
                      _td(voucher.hsnCode ?? '7113'),
                      _td(_currencyFormat.format(voucher.taxableAmount)),
                      _td('${voucher.taxSlabPercent.toStringAsFixed(1)}%'),
                      _td(_currencyFormat.format(voucher.totalAmount)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 6),

              // Tax Summary Box
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Taxable Value:', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(_currencyFormat.format(voucher.taxableAmount), style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('CGST (${(voucher.taxSlabPercent / 2).toStringAsFixed(1)}%):', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(_currencyFormat.format(voucher.cgstAmount), style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('SGST (${(voucher.taxSlabPercent / 2).toStringAsFixed(1)}%):', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text(_currencyFormat.format(voucher.sgstAmount), style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                    pw.Divider(thickness: 0.5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'GRAND TOTAL:',
                          style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          _currencyFormat.format(voucher.totalAmount),
                          style: const pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Barcode
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: voucher.billNumber,
                  width: 110,
                  height: 24,
                  drawText: false,
                ),
              ),
              pw.SizedBox(height: 10),

              // Signature
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 75,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                        ),
                      ),
                      pw.Text('Buyer Signature', style: const pw.TextStyle(fontSize: 7)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 75,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                        ),
                      ),
                      pw.Text('Authorized Signatory', style: const pw.TextStyle(fontSize: 7)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              // Watermark
              if (watermarkText != null) ...[
                pw.Divider(thickness: 0.5),
                pw.Center(
                  child: pw.Text(
                    watermarkText.toUpperCase(),
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Triggers standard cross-platform print preview dialog.
  static Future<void> printSlip(
    BuildContext context, {
    required Future<Uint8List> Function() onGeneratePdf,
    String documentName = 'tijori_slip',
  }) async {
    await Printing.layoutPdf(
      onLayout: (format) => onGeneratePdf(),
      name: documentName,
    );
  }

  static pw.Widget _th(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _td(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 7),
      ),
    );
  }
}
