import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tijori/core/database/app_database.dart';

/// Thermal and A4 slip printing engine for Tijori Jewellery ERP.
abstract final class SlipPrinter {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: 'Rs. ',
    decimalDigits: 2,
  );
  static final _dateFormat = DateFormat('dd-MMM-yyyy');
  static final _dateTimeFormat = DateFormat('dd-MMM-yyyy hh:mm a');

  /// Generates a PDF byte stream for a Girvi Loan Pledge slip.
  static Future<Uint8List> generateGirviSlipPdf({
    required GirviLoan loan,
    required Party party,
    String? shopName,
    String? shopPhone,
    String? shopAddress,
    String? watermarkText,
    bool isThermal = true,
  }) async {
    final pdf = pw.Document();
    final format = isThermal
        ? const PdfPageFormat(
            72 * PdfPageFormat.mm,
            double.infinity,
            marginAll: 4 * PdfPageFormat.mm,
          )
        : PdfPageFormat.a5;

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
              pw.Text(
                'Description: ${loan.itemDescription}',
                style: const pw.TextStyle(fontSize: 8),
              ),
              if (loan.rackLocation != null && loan.rackLocation!.isNotEmpty)
                pw.Text(
                  'Vault / Rack: ${loan.rackLocation}',
                  style: const pw.TextStyle(fontSize: 8),
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
    String? watermarkText,
    bool isThermal = true,
  }) async {
    final pdf = pw.Document();
    final format = isThermal
        ? const PdfPageFormat(
            72 * PdfPageFormat.mm,
            double.infinity,
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
