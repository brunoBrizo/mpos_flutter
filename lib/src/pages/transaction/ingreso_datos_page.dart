import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/transaccion_database.dart';
import 'package:mpos/src/logic/webservice_logic.dart';
import 'package:mpos/src/logic/xml/logic_xmlwebservice.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/moneda_modelo.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';
import 'package:mpos/src/pages/sidebar/sidebar_page.dart';
import 'package:mpos/src/utils/decimalTextInputFormatter_utils.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/logic/initialize_logic.dart' as initialize_logic;

class IngresoDatos extends StatefulWidget {
  @override
  _IngresoDatosState createState() => _IngresoDatosState();
}

class _IngresoDatosState extends State<IngresoDatos> {
  @override
  void initState() {
    super.initState();
    initialize_logic.inicializar(context);
  }

  final formKey = GlobalKey<FormState>();

  //Variables controllers
  TextEditingController fieldControllerImporteFactura =
      new TextEditingController();
  TextEditingController fieldControllerImporteGravado =
      new TextEditingController();
  TextEditingController fieldControllerCuotas = new TextEditingController();
  TextEditingController fieldControllerNumFactura = new TextEditingController();
  String fieldControllerMoneda = 'Pesos';
  bool fieldControllerConsumidorFinal = true;

  @override
  Widget build(BuildContext context) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: utils.drawAppBar(
            (bloc.tipoTransaccion == TipoTransaccion.Venta
                ? 'Venta'
                : 'Devolución'),
            true),
        body: _drawBody(context, size),
      ),
    );
  }

  _drawBody(BuildContext context, Size size) {
    return utils.isMobile(context)
        ? _drawBodyMobile(context, size)
        : _drawBodyDesktopWeb(context, size);
  }

  _drawBodyMobile(BuildContext context, Size size) {
    double widthTexts = size.width;
    if (widthTexts > 1000) widthTexts = widthTexts / 1.3;
    widthTexts = (utils.isWeb() || utils.isWindowsDesktop())
        ? widthTexts * 0.4
        : widthTexts;

    return Stack(children: <Widget>[
      Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              _createConsumidorFinal(context, widthTexts),
              _createImporte(context, widthTexts),
              SizedBox(
                height: size.height * 0.02,
              ),
              _createImporteFactura(context, widthTexts),
              SizedBox(
                height: size.height * 0.02,
              ),
              _createImporteGravado(context, widthTexts),
              SizedBox(
                height: size.height * 0.02,
              ),
              _createCuotas(context, widthTexts),
              SizedBox(
                height: size.height * 0.02,
              ),
              _createComboMoneda(context, widthTexts),
              SizedBox(
                height: size.height * 0.02,
              ),
              _createNumFactura(context, widthTexts),
              SizedBox(
                height: size.height * 0.02,
              ),
              _createSubmit(context, size, widthTexts)
            ],
          ),
        ),
      ),
    ]);
  }

  _drawBodyDesktopWeb(BuildContext context, Size size) {
    return Row(children: <Widget>[
      SideBar.drawSideBar(context),
      Expanded(flex: 4, child: _drawBodyMobile(context, size))
    ]);
  }

  Widget _createConsumidorFinal(BuildContext context, double width) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.consumidorFinalStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FadeIn(
          delay: Duration(milliseconds: 800),
          child: Container(
              width: width,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: CheckboxListTile(
                title: Text(
                  "Consumidor final",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
                value: fieldControllerConsumidorFinal,
                activeColor: Color.fromRGBO(110, 10, 0, 1.0),
                onChanged: (newValue) {
                  setState(() {
                    fieldControllerConsumidorFinal = newValue;
                    bloc.changeConsumidorFinal(newValue);
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.platform, //  <-- leading Checkbox
              )),
        );
      },
    );
  }

  Widget _createImporte(BuildContext context, double width) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.importeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FadeIn(
          delay: Duration(milliseconds: 850),
          child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                initialValue: bloc.importe.toString(),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                readOnly: true,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Importe',
                ),
                validator: (value) {
                  if (utils.isDecimal(value)) {
                    return null;
                  } else {
                    return 'Importe debe ser un valor numérico';
                  }
                },
              )),
        );
      },
    );
  }

  Widget _createImporteFactura(BuildContext context, double width) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.importeFacturaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FadeIn(
          delay: Duration(milliseconds: 900),
          child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: fieldControllerImporteFactura
                  ..text = bloc.importeFactura.toString()
                  ..selection = TextSelection.collapsed(
                      offset: utils.isWeb()
                          ? fieldControllerImporteFactura.text.length
                          : fieldControllerImporteFactura.text.length - 3),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                readOnly: false,
                obscureText: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Importe Factura',
                    errorMaxLines: 3),
                onChanged: (newValue) {
                  fieldControllerImporteFactura
                    ..text = bloc.importeFactura.toString()
                    ..selection = TextSelection.collapsed(
                        offset: fieldControllerImporteFactura.text.length - 3);
                  setState(() {
                    if (utils.isDecimal(newValue)) {
                      double newImporteFactura = double.tryParse(newValue);
                      bloc.changeImporteFactura(newImporteFactura);
                      print('cambia');
                    } else {
                      bloc.changeImporteFactura(0.00);
                    }
                  });
                },
              )),
        );
      },
    );
  }

  Widget _createImporteGravado(BuildContext context, double width) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.importeGravadoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FadeIn(
          delay: Duration(milliseconds: 950),
          child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: fieldControllerImporteGravado
                  ..text = bloc.importeGravado.toString()
                  ..selection = TextSelection.collapsed(
                      offset: fieldControllerImporteGravado.text.length - 3),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                readOnly: false,
                obscureText: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Importe Gravado',
                    errorMaxLines: 3),
                onChanged: (newValue) {
                  fieldControllerImporteGravado
                    ..text = bloc.importeGravado.toString();
                  setState(() {
                    if (utils.isDecimal(newValue)) {
                      double newImporteGravado = double.tryParse(newValue);
                      bloc.changeImporteGravado(newImporteGravado);
                    } else {
                      bloc.changeImporteGravado(0.00);
                    }
                  });
                },
              )),
        );
      },
    );
  }

  Widget _createCuotas(BuildContext context, double width) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.cuotasStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FadeIn(
          delay: Duration(milliseconds: 1000),
          child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: fieldControllerCuotas
                  ..text = bloc.cuotas.toString()
                  ..selection = TextSelection.collapsed(
                      offset: fieldControllerCuotas.text.length),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                readOnly: false,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cuotas',
                ),
                onChanged: (newValue) {
                  setState(() {
                    if (utils.isNumeric(newValue)) {
                      int newCuotas = int.tryParse(newValue);
                      bloc.changeCuotas(newCuotas);
                    } else {
                      bloc.changeCuotas(0);
                    }
                  });
                },
              )),
        );
      },
    );
  }

  Widget _createComboMoneda(BuildContext context, double width) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    List _monedas = ['Pesos', 'Dolares'];

    return StreamBuilder(
      stream: bloc.monedaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FadeIn(
          delay: Duration(milliseconds: 1050),
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: DropdownButton<String>(
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  hint: Text('Moneda',
                      style: TextStyle(fontSize: 15.0, color: Colors.black)),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(110, 10, 0, 1.0),
                    size: 40.0,
                  ),
                  isExpanded: true,
                  value: fieldControllerMoneda,
                  items: _monedas.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      fieldControllerMoneda = value;
                      int newMoneda = 0;
                      if (value == 'Pesos') {
                        newMoneda = 1;
                      } else {
                        newMoneda = 2;
                      }
                      bloc.changeMoneda(newMoneda);
                    });
                  },
                )),
          ),
        );
      },
    );
  }

  Widget _createNumFactura(BuildContext context, double width) {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);

    return StreamBuilder(
      stream: bloc.numFacturaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FadeIn(
          delay: Duration(milliseconds: 1100),
          child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: fieldControllerNumFactura
                  ..text = bloc.numFactura.toString()
                  ..selection = TextSelection.collapsed(
                      offset: fieldControllerNumFactura.text.length),
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(7),
                ],
                readOnly: false,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Número de Factura',
                ),
                onChanged: (newValue) {
                  setState(() {
                    if (utils.isNumeric(newValue)) {
                      int newNumFactura = int.tryParse(newValue);
                      bloc.changeNumFactura(newNumFactura);
                    } else {
                      bloc.changeNumFactura(0);
                    }
                  });
                },
              )),
        );
      },
    );
  }

  Widget _createSubmit(BuildContext context, Size size, double width) {
    return BounceInUp(
      delay: Duration(milliseconds: 1400),
      child: SizedBox(
        height: size.height * 0.11,
        width: width, // size.width * 0.6,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Color.fromRGBO(110, 10, 0, 1.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            icon: Icon(
              Icons.monetization_on,
              size: utils.isWeb() ? 70 : size.height * size.width * 0.00016,
            ),
            label: Text('Cobrar',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            onPressed: _submit),
      ),
    );
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(this.context);
      String errorMsg;
      bool error = false;
      if (bloc.importe > 999999999.00) {
        error = true;
        errorMsg = 'Importe debe ser menor a 999.999.999,00';
      }
      if (!error && bloc.importeFactura > bloc.importe) {
        error = true;
        errorMsg = 'Importe factura debe ser menor o igual a Importe';
      }
      if (!error && bloc.importeGravado > bloc.importeFactura) {
        errorMsg = 'Importe Gravado debe ser menor o igual a Importe Factura';
      }
      if (!error && bloc.cuotas > 99) {
        error = true;
        errorMsg = 'Cuotas debe ser menor o igual a 99';
      }
      if (!error && bloc.numFactura.toString().length > 7) {
        error = true;
        errorMsg = 'Número de Factura admite hasta 7 dígitos';
      }
      if (error) {
        EasyLoading.showError(errorMsg);
      } else {
        bloc.changeCuotas(int.parse(fieldControllerCuotas.text));
        bloc.changeImporteFactura(
            double.parse(fieldControllerImporteFactura.text));
        bloc.changeImporteGravado(
            double.parse(fieldControllerImporteGravado.text));
        bloc.changeMoneda(fieldControllerMoneda == "Pesos" ? 1 : 2);
        bloc.changeNumFactura(int.parse(fieldControllerNumFactura.text));
        bloc.changeConsumidorFinal(fieldControllerConsumidorFinal);

        String xml = ensamblarXMLTransaccion(bloc);

        postearTransaccion(context, xml);
      }
    }
  }

  void postearTransaccion(BuildContext context, String xml) async {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);
    try {
      bool posteada = await callWSPostearTransaccion(context, xml);
      if (posteada) {
        if (bloc.transaccionAprobada) {
          EasyLoading.showSuccess(
            bloc.mensajeRespuesta,
          );
          await insertTransaccionDB(context);
          if (bloc.tipoTransaccion == TipoTransaccion.Devolucion) {
            TransaccionDatabase trnDb = new TransaccionDatabase();
            await trnDb.setTrnDevuelta(bloc.ticketOriginal);
          }

          bool trnNeedSignature = bloc.respuestaTransaccion.firmarVoucher;
          bool goToSignature = false;

          if (trnNeedSignature) {
            goToSignature = _checkGoToSignature();
          }

          if (goToSignature)
            Navigator.pushReplacementNamed(context, 'signature');
          else
            Navigator.pushReplacementNamed(context, 'resumen');
        } else {
          EasyLoading.showError(
            bloc.mensajeRespuesta,
          );
          Navigator.pushReplacementNamed(context, 'home');
        }
      } else {
        EasyLoading.showError(
          bloc.mensajeRespuesta,
        );
        Navigator.pushReplacementNamed(context, 'home');
      }
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  //PRECONDICION: se llama solamente si el ticket pide signature
  _checkGoToSignature() {
    LoginBloc bloc = Provider.loginBloc(context);
    bool empSolicitarSignature = bloc.empresa.solicitarSignature;
    if (empSolicitarSignature)
      return true;
    else
      return false;
  }

  Future<void> insertTransaccionDB(BuildContext context) async {
    DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);
    try {
      TransaccionDatabase trnDb = new TransaccionDatabase();
      Transaccion trn = cargarDatosTrn(bloc);
      await trnDb.insertTrn(trn);
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  Transaccion cargarDatosTrn(DatosTransaccionBloc blocTrn) {
    Transaccion trn = new Transaccion();
    trn.aprobada = blocTrn.transaccionAprobada;
    trn.codigoRespuesta = blocTrn.codigoRespuesta;
    trn.cuotas = blocTrn.respuestaTransaccion.cuotas;
    trn.decretoLeyMonto = blocTrn.respuestaTransaccion.decretoLeyMonto;
    trn.empCod = blocTrn.empCod;
    trn.facturaMonto = blocTrn.respuestaTransaccion.facturaMonto;
    trn.facturaMontoGravado = blocTrn.respuestaTransaccion.facturaMontoGravado;
    trn.facturaMontoIva = blocTrn.respuestaTransaccion.facturaMontoIva;
    trn.fecha = blocTrn.respuestaTransaccion.fecha;
    trn.firmarVoucher = blocTrn.respuestaTransaccion.firmarVoucher;
    trn.fueDevuelto = blocTrn.respuestaTransaccion.fueDevuelto;
    trn.id = blocTrn.respuestaTransaccion.id;
    trn.mensajeRespuesta = blocTrn.mensajeRespuesta;
    trn.mid = blocTrn.respuestaTransaccion.mid;
    Moneda moneda = new Moneda(blocTrn.respuestaTransaccion.moneda, '', '');
    trn.moneda = moneda;
    trn.monto = blocTrn.respuestaTransaccion.monto;
    trn.montoPropina = blocTrn.respuestaTransaccion.montoPropina;
    trn.nroAutorizacion = blocTrn.respuestaTransaccion.nroAutorizacion;
    trn.nroFactura = blocTrn.respuestaTransaccion.nroFactura;
    trn.tarjetaNombre = blocTrn.respuestaTransaccion.tarjetaNombre;
    trn.tarjetaNumero = blocTrn.respuestaTransaccion.tarjetaNumero;
    trn.tarjetaTitular = blocTrn.respuestaTransaccion.tarjetaTitular;
    trn.termCod = blocTrn.termCod;
    trn.terminalId = blocTrn.respuestaTransaccion.terminalId;
    trn.ticket = blocTrn.respuestaTransaccion.ticket;
    trn.tipo = blocTrn.tipoTransaccion;
    trn.tokenNro = blocTrn.respuestaTransaccion.tokenNro;
    trn.tokenSegundosConsultar = blocTrn.tokenSegundos;
    trn.user = blocTrn.respuestaTransaccion.user;
    trn.tarjetaId = blocTrn.respuestaTransaccion.tarjetaId;
    return trn;
  }
}
