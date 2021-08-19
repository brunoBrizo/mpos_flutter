import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:share/share.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/logic/voucherpdf_logic.dart' as voucherpdf_logic;

class Resumen extends StatefulWidget {
  @override
  _ResumenState createState() => _ResumenState();
}

class _ResumenState extends State<Resumen> {
  final formKey = GlobalKey<FormState>();
  ParametroDatabase paramDb = new ParametroDatabase();
  String _notificacionSelected = 'Email';
  List _notificaciones = [
    'No Notificar',
    'Email',
    'WhatsApp',
    'Elegir al momento'
  ];

  @override
  void initState() {
    super.initState();
    getParametroNotificacion();
  }

  Future getParametroNotificacion() async {
    try {
      Parametro paramNotificacion = await paramDb.getParametro(1);
      setState(() {
        _notificacionSelected =
            _notificaciones[int.parse(paramNotificacion.valor)];
      });
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return new WillPopScope(
        onWillPop: () async {
          utils.limpiarDatosBloc(context);
          Navigator.popAndPushNamed(context, 'home');
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: utils.drawAppBar('Resumen', false),
            body: _drawBody(size),
          ),
        ));
  }

  _drawBody(Size size) {
    return new SingleChildScrollView(
      clipBehavior: Clip.none,
      dragStartBehavior: DragStartBehavior.start,
      scrollDirection: Axis.vertical,
      primary: false,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _createInfoTicket(context),
                _createInfoFactura(context)
              ],
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _createInfoCuotas(context),
              ],
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_createInfoAutorizacion(context)],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            _drawForm(size),
          ],
        ),
      ),
    );
  }

  _drawForm(Size size) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          _createImporte(context),
          SizedBox(
            height: size.height * 0.005,
          ),
          _createPropina(context),
          SizedBox(
            height: size.height * 0.005,
          ),
          _createDevLey(context),
          SizedBox(
            height: size.height * 0.005,
          ),
          _createTotal(context),
          SizedBox(
            height: size.height * 0.005,
          ),
          _createRespuesta(context),
          SizedBox(
            height: size.height * 0.005,
          ),
          _createNotificacion(),
          SizedBox(
            height: size.height * 0.005,
          ),
          _createSubmit(context, size)
        ],
      ),
    );
  }

  Widget _createInfoTicket(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.importeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Text(
                "Ticket: " + bloc.respuestaTransaccion.ticket.toString(),
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ));
      },
    );
  }

  Widget _createInfoFactura(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.importeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Text(
                "Factura: " + bloc.numFactura.toString(),
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ));
      },
    );
  }

  Widget _createInfoCuotas(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.cuotasStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              child: Text(
                "Cuotas: " + bloc.cuotas.toString(),
                style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
              ),
            ));
      },
    );
  }

  Widget _createInfoAutorizacion(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.respuestaTransaccion.nroAutorizacionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Container(
                  child: Text(
                    "Autorización",
                    style:
                        TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(
                    bloc.respuestaTransaccion.nroAutorizacion,
                    style: TextStyle(fontSize: 23.0),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _createImporte(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.importeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              textAlign: TextAlign.right,
              initialValue: bloc.importe.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              readOnly: true,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Importe',
                  prefixStyle: TextStyle(fontSize: 20.0)),
            ));
      },
    );
  }

  Widget _createPropina(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.respuestaTransaccion.montoPropinaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              textAlign: TextAlign.right,
              initialValue: bloc.respuestaTransaccion.montoPropina.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              readOnly: true,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Propina',
                  prefixStyle: TextStyle(fontSize: 20.0)),
            ));
      },
    );
  }

  Widget _createDevLey(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.respuestaTransaccion.decretoLeyMontoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              textAlign: TextAlign.right,
              initialValue:
                  bloc.respuestaTransaccion.decretoLeyMonto.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              readOnly: true,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Dev. Ley',
                  prefixStyle: TextStyle(fontSize: 20.0)),
            ));
      },
    );
  }

  Widget _createTotal(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.importeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              textAlign: TextAlign.right,
              initialValue: bloc.importe.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              readOnly: true,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Total',
                  prefixStyle: TextStyle(fontSize: 20.0)),
            ));
      },
    );
  }

  Widget _createRespuesta(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.respuestaTransaccion.aprobadaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              textAlign: TextAlign.right,
              initialValue: (bloc.respuestaTransaccion.aprobada == true
                  ? 'APROBADA'
                  : 'NO APROBADA'),
              keyboardType: TextInputType.text,
              readOnly: true,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Respuesta',
                  prefixStyle: TextStyle(fontSize: 20.0)),
            ));
      },
    );
  }

  Widget _createNotificacion() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: DropdownButton<String>(
            style: TextStyle(fontSize: 15.0, color: Colors.black),
            hint: Text('Notificación',
                style: TextStyle(fontSize: 15.0, color: Colors.black)),
            icon: Icon(
              Icons.arrow_drop_down,
              size: 40.0,
              color: Color.fromRGBO(110, 10, 0, 1.0),
            ),
            isExpanded: true,
            value: _notificacionSelected,
            items: _notificaciones.map((value) {
              return new DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _notificacionSelected = value;
              });
            },
          )),
    );
  }

  Widget _createSubmit(BuildContext context, Size size) {
    return SizedBox(
      height: size.height * 0.1,
      width: size.width * 0.6,
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.restore_page,
          size: size.height * size.width * 0.00016,
        ),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Color.fromRGBO(110, 10, 0, 1.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
        label: Text('Finalizar',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
        onPressed: () {
          _submit(context);
        },
      ),
    );
  }

  void _submit(BuildContext context) async {
    formKey.currentState.validate();

    //TODO: check what to do with the png
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);
    final String signaturePngPath = bloc.signaturePngPath;
    if (signaturePngPath != null && signaturePngPath.isNotEmpty) {
      File pngFile = File(signaturePngPath);
      await pngFile.delete();
    }

    switch (_notificacionSelected) {
      case 'No Notificar':
        {
          utils.limpiarDatosBloc(context);
          Navigator.popAndPushNamed(context, 'home');
        }
        break;

      case 'Email':
        {
          await _sendEmail(context);
          utils.limpiarDatosBloc(context);
        }
        break;

      case 'Elegir al momento':
        {
          await _elegirApp(context);
          utils.limpiarDatosBloc(context);
        }
        break;

      case 'WhatsApp':
        {
          await _sendWhatsApp(context);
          utils.limpiarDatosBloc(context);
        }
        break;

      default:
        {
          utils.limpiarDatosBloc(context);
          Navigator.popAndPushNamed(context, 'home');
        }
        break;
    }
    utils.limpiarDatosBloc(context);
    Navigator.popAndPushNamed(context, 'home');
  }

  _sendEmail(BuildContext context) async {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);
    String voucherResult = voucherpdf_logic
        .assemblyCustomerVoucher(bloc.respuestaTransaccion.voucher);

    String pathToPDF = await voucherpdf_logic.createPDFFile(voucherResult);
    final Email email = Email(
      body:
          "Estimado cliente, se adjunta el ticket correspondiente a la factura emitida con los datos siguientes: \n\n" +
              "Empresa: " +
              bloc.empCod +
              "\n" +
              "Terminal: " +
              bloc.termCod +
              "\n" +
              "Nro Ticket: " +
              bloc.respuestaTransaccion.ticket.toString() +
              "\n" +
              "Monto: " +
              bloc.respuestaTransaccion.monto.toString() +
              "\n" +
              "Fecha: " +
              bloc.respuestaTransaccion.fecha.toString() +
              "\n",
      subject: "Factura mPOS NAD" +
          (bloc.numFactura == 0 ? "." : " Nro. " + bloc.numFactura.toString()),
      recipients: [],
      attachmentPaths: [pathToPDF],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  _elegirApp(BuildContext context) async {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);
    String voucherResult = voucherpdf_logic
        .assemblyCustomerVoucher(bloc.respuestaTransaccion.voucher);
    String pathToPDF = await voucherpdf_logic.createPDFFile(voucherResult);
    String subject = "Factura mPOS NAD" +
        (bloc.numFactura == 0 ? "." : " Nro. " + bloc.numFactura.toString());
    await Share.shareFiles(
      [pathToPDF],
      text: subject,
    );
  }

  _sendWhatsApp(BuildContext context) async {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    String msg =
        "Estimado cliente, se adjunta el ticket correspondiente a la factura emitida con los datos siguientes: \n\n" +
            "Empresa: " +
            bloc.empCod +
            "\n" +
            "Terminal: " +
            bloc.termCod +
            "\n" +
            "Nro Ticket: " +
            bloc.respuestaTransaccion.ticket.toString() +
            "\n" +
            "Monto: " +
            bloc.respuestaTransaccion.monto.toString() +
            "\n" +
            "Fecha: " +
            bloc.respuestaTransaccion.fecha.toString() +
            "\n" +
            "Factura mPOS NAD" +
            (bloc.numFactura == 0
                ? "."
                : " Nro. " + bloc.numFactura.toString());

    String voucherResult = voucherpdf_logic
        .assemblyCustomerVoucher(bloc.respuestaTransaccion.voucher);

    String pathToPDF = await voucherpdf_logic.createPDFFile(voucherResult);
    Share.shareFiles(
      [pathToPDF],
      text: msg,
    );
  }
}
