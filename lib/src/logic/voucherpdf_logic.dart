import 'dart:convert';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';
import 'package:path_provider/path_provider.dart';

String assemblyCustomerVoucher(String originalVoucher) {
  LineSplitter ls = new LineSplitter();
  List<String> lines = ls.convert(originalVoucher);
  String voucherResult = "";
  bool flagInicioVoucherCliente = false;
  for (var i = 0; i < lines.length; i++) {
    lines[i] = lines[i]
        .replaceAll("#CF#", "")
        .replaceAll("/I", "")
        .replaceAll("/N", "")
        .replaceAll("/H", "")
        .replaceAll("#LOGO#", "")
        .replaceAll("#BR#", "");

    if (flagInicioVoucherCliente) voucherResult += lines[i] + "\n";

    if (lines[i].contains("*** COPIA COMERCIO *** "))
      flagInicioVoucherCliente = true;
  }
  return voucherResult;
}

String assemblyCustomerVoucherReShare(Transaccion trnOriginal) {
  String voucherResult = "";
  voucherResult += trnOriginal.fecha.toString() + "\n";
  voucherResult +=
      (trnOriginal.tipo == TipoTransaccion.Venta ? "VENTA" : "DEVOLUCION") +
          " - ";
  voucherResult += trnOriginal.tarjetaNombre + "\n";
  voucherResult += "Empresa: " + " " + trnOriginal.empCod + "\n";
  voucherResult += "Terminal: " + " " + trnOriginal.termCod.toString() + "\n";
  voucherResult += "Ticket: " + " " + trnOriginal.ticket.toString() + "\n";
  voucherResult += "Tarjeta: " + " " + trnOriginal.tarjetaNumero + "\n";
  voucherResult += "Cuotas: " + " " + trnOriginal.cuotas.toString() + "\n";
  voucherResult +=
      "Moneda: " + " " + (trnOriginal.moneda.value == 2 ? "UYU" : "USD") + "\n";
  voucherResult += "Monto: " + " " + trnOriginal.monto.toString() + "\n";
  return voucherResult;
}

Future<String> createPDFFile(String dataContent) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, 180 * PdfPageFormat.mm,
          marginLeft: 2.5 * PdfPageFormat.mm),
      build: (context) {
        return pw.Center(
          child: pw.Text(dataContent),
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/mposnad_factura.pdf");
  await file.writeAsBytes(await pdf.save());
  return file.path.toString();
}
