import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class PrintService {
  static Future<void> printReceipt(Transaction transaction) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'POS APP',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Aplikasi Point of Sales',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Jl. Soekarno-Hatta No. 123, Jepara',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      'Telp: (021) 1234-5678',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              
              pw.Divider(),
              
              // Transaction Info
              pw.Text(
                'Struk Pembayaran',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'No: ${transaction.id.substring(transaction.id.length - 6)}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Tanggal: ${DateFormat('dd/MM/yyyy HH:mm').format(transaction.date)}',
                style: pw.TextStyle(fontSize: 10),
              ),
              
              pw.Divider(),
              
              // Items
              pw.Text(
                'Barang yang Dibeli:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              
              ...transaction.items.map((item) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            item.productName,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            '${item.quantity} x Rp ${NumberFormat('#,###').format(item.price)}',
                            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Rp ${NumberFormat('#,###').format(item.subtotal)}',
                        style: pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              )),
              
              pw.Divider(),
              
              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Rp ${NumberFormat('#,###').format(transaction.totalPrice)}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 16),
              
              // Footer
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Terima Kasih',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Atas Kunjungan Anda',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Barang yang sudah dibeli',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'tidak dapat dikembalikan',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static Future<void> printReceiptToFile(Transaction transaction, String filePath) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'POS APP',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Aplikasi Point of Sales',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Jl. Contoh No. 123, Jakarta',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      'Telp: (021) 1234-5678',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              
              pw.Divider(),
              
              // Transaction Info
              pw.Text(
                'Struk Pembayaran',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'No: ${transaction.id.substring(transaction.id.length - 6)}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Tanggal: ${DateFormat('dd/MM/yyyy HH:mm').format(transaction.date)}',
                style: pw.TextStyle(fontSize: 10),
              ),
              
              pw.Divider(),
              
              // Items
              pw.Text(
                'Item yang Dibeli:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              
              ...transaction.items.map((item) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            item.productName,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            '${item.quantity} x Rp ${NumberFormat('#,###').format(item.price)}',
                            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Rp ${NumberFormat('#,###').format(item.subtotal)}',
                        style: pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              )),
              
              pw.Divider(),
              
              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Rp ${NumberFormat('#,###').format(transaction.totalPrice)}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 16),
              
              // Footer
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Terima Kasih',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Atas Kunjungan Anda',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Barang yang sudah dibeli',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'tidak dapat dikembalikan',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save to file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }
} 