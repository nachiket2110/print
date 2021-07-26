import 'dart:io';
import 'package:intl/intl.dart';
import 'package:generate_pdf_invoice_example/api/pdf_api.dart';
import 'package:generate_pdf_invoice_example/model/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(invoice),
        Divider(),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Apptmart Merchant Console.pdf', pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            Text(
              DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
            ),
            pw.SizedBox(width: 100),
            Text("Apptmart Merchant Console", style: TextStyle(fontSize: 12)),
          ]),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Column(children: [
            Text(
              'Foodies Corner',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
                "Shop No.11,12 and 13, Mithali Heights,Near KDMC D ward Office,\nPune Link Road, Kalyan (E) 421306",
                textAlign: pw.TextAlign.center),
          ]),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text("+91 9657778297"),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Divider(),
          Text("Order Number:1850",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Row(children: [
            Text("15-jul-2021"),
            SizedBox(width: 370),
            Text("13:05:56"),
          ]),
          Divider(),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text("Delivery",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          Text("Santawana Chouhan"),
          Text(
              "JijaMata Colony ,Joshibaug,Kalyan,\nThane,Maharashtra 421301,India, 9, k",
              textAlign: pw.TextAlign.center),
          Text("+91 9657778297"),
        ],
      );

  //build table for the order data
  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Product Name', 'Quantity', 'Amount'];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        '${item.quantity}',
        '\ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
      },
    );
  }

  //build total values
  static Widget buildTotal(Invoice invoice) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Spacer(flex: 5),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Delivery Charges',
                  value: '123',
                  // unite: true,
                ),
                buildText(
                  title: 'Your Total savings',
                  value: '123',
                  // unite: true,
                ),
                buildText(
                  title: 'Total',
                  value: '123',
                  // unite: true,
                ),
                buildText(
                  title: 'Payment Method',
                  value: "Gpay",
                  // unite: true,
                ),
                buildText(
                  title: 'Delivery Method',
                  value: "Delivery",
                  // unite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Thank you, Visit Again..!!"),
          Divider(),
        ],
      );

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: pw.FontWeight.normal);
    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
