import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/pages/sidebar/sidebar_page.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/logic/initialize_logic.dart' as initialize_logic;

class IngresoImportePage extends StatefulWidget {
  @override
  _IngresoImportePageState createState() => _IngresoImportePageState();
}

class _IngresoImportePageState extends State<IngresoImportePage> {
  bool expanded = true;

  var _input = '';
  EmpresaDatabase empDb = new EmpresaDatabase();
  Box empBox;

  @override
  void initState() {
    super.initState();
    initialize_logic.inicializar(context);
    _inicializarEmp();
  }

  @override
  void dispose() async {
    try {
      super.dispose();
      await empDb.dispose();
    } catch (error) {}
  }

  _inicializarEmp() async {
    try {
      empBox = await empDb.initEmpresa();
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return utils.isMobile(context)
        ? SafeArea(
            child: Scaffold(
              drawer: SideBar.drawSideBar(context),
              appBar: utils.drawAppBar('Importe', true),
              body: _drawBody(context, size),
              floatingActionButton: _drawFloatingActionButton(),
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            ),
          )
        : Scaffold(
            appBar: utils.drawAppBar('Importe', true),
            body: _drawBody(context, size),
            floatingActionButton: _drawFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          );
  }

  _drawBody(BuildContext context, Size size) {
    return utils.isMobile(context)
        ? _drawBodyMobile(context, size)
        : _drawBodyDesktopWeb(context, size);
  }

  _drawBodyMobile(BuildContext context, Size size) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        _drawTitle(),
        SizedBox(
          height: 60,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(_input, style: TextStyle(color: Colors.black, fontSize: 45.0)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        SizedBox(
          height: 80,
        ),
        Expanded(
            flex: 1,
            child: Container(
                color: Colors.black87,
                child: Column(
                  children: <Widget>[
                    _firstLine(size),
                    _secondLine(size),
                    _thirdLine(size),
                    _fourthLine(size)
                  ],
                )))
      ],
    );
  }

  _drawBodyDesktopWeb(BuildContext context, Size size) {
    return Row(children: <Widget>[
      SideBar.drawSideBar(context),
      Expanded(flex: 4, child: _drawBodyMobile(context, size))
    ]);
  }

  _drawFloatingActionButton() {
    return SlideInRight(
      duration: Duration(milliseconds: 1300),
      child: FloatingActionButton(
        backgroundColor: (utils.isWeb() || utils.isWindowsDesktop())
            ? Colors.black
            : Colors.black38,
        mini: false,
        // child: AnimatedImage(
        //   imageToAnimate: "assets/images/next.png",
        //   imageSizeToAnimate: 55,
        //   animationDuration: 1,
        //   animationType: CustomAnimationType.size,
        // ),

        child: Image.asset(
          "assets/images/next.png",
          color: Colors.white70,
          height: 55.0,
        ),
        onPressed: () async {
          await _facturar();
        },
      ),
    );
  }

  _facturar() async {
    try {
      bool error = false;
      if (_input.isEmpty) {
        error = true;
        EasyLoading.showError('Debe ingresar el importe');
      }

      if (!error) {
        double inputValue = double.parse(_input);
        if (inputValue > 999999999) {
          error = true;
          EasyLoading.showError('Importe debe ser menor a 999.999.999,00');
        }
      }

      if (!error) {
        LoginBloc blocLogin = Provider.loginBloc(context);
        ParametroDatabase parametroDatabase = new ParametroDatabase();
        Parametro paramLogin = await parametroDatabase.getParametro(5);
        blocLogin.changeEmail(paramLogin.valor);

        DatosTransaccionBloc datosBloc = Provider.datosTransaccionBloc(context);
        double importe = double.parse(_input);
        datosBloc.changeTipoTransaccion(TipoTransaccion.Venta);
        datosBloc.changeTicketOriginal(0);
        datosBloc.changeImporte(importe);
        datosBloc.changeImporteFactura(importe);
        String importeGravadoString =
            (importe / (1 + (22 / 100))).toStringAsFixed(2);
        datosBloc.changeImporteGravado(double.parse(importeGravadoString));
        datosBloc.changeCuotas(1);
        datosBloc.changeNumFactura(0);
        datosBloc.changeMoneda(1);
        datosBloc.changeConsumidorFinal(true);
        Empresa emp = await empDb.getEmpresa(1);
        datosBloc.changeEmpCod(emp.codigo);
        datosBloc.changeTermCod(emp.codigoTerminal);
        datosBloc.changeEmpHashCod(emp.hash);

        Navigator.pushNamed(context, 'ingreso_datos');
      }
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  Widget _firstLine(Size size) {
    return Expanded(
      child: Row(
        children: <Widget>[
          _drawButton('1', size),
          _drawButton('2', size),
          _drawButton('3', size),
        ],
      ),
    );
  }

  Widget _secondLine(Size size) {
    return Expanded(
      child: Row(
        children: <Widget>[
          _drawButton('4', size),
          _drawButton('5', size),
          _drawButton('6', size),
        ],
      ),
    );
  }

  Widget _thirdLine(Size size) {
    return Expanded(
      child: Row(
        children: <Widget>[
          _drawButton('7', size),
          _drawButton('8', size),
          _drawButton('9', size),
        ],
      ),
    );
  }

  Widget _fourthLine(Size size) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child: SlideInUp(
              duration: Duration(milliseconds: 1300),
              child: MaterialButton(
                padding: EdgeInsets.all(utils.isWebOrDesktop() ? 1 : 35),
                shape: CircleBorder(),
                height: utils.isWebOrDesktop() ? 80 : 35,
                onPressed: () {
                  setState(() {
                    if (!_input.contains('.') && _input.isNotEmpty) {
                      if (_input.length <= 7) _input += '.';
                    }
                  });
                },
                child: Text(
                  '.',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
              ),
            ),
          ),
          _drawButton('0', size),
          Expanded(
            child: SlideInUp(
              duration: Duration(milliseconds: 1300),
              child: MaterialButton(
                  padding: EdgeInsets.all(utils.isWebOrDesktop() ? 1 : 35),
                  shape: CircleBorder(),
                  height: utils.isWebOrDesktop() ? 80 : 35,
                  onPressed: () {
                    setState(() {
                      _input = _input.length >= 1
                          ? _input.substring(0, _input.length - 1)
                          : '';
                    });
                  },
                  child: Icon(
                    Icons.backspace,
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _drawButton(var value, Size size) {
    double paddingValue = (utils.isWeb() || utils.isWindowsDesktop()) ? 25 : 35;
    return Expanded(
        child: SlideInUp(
      duration: Duration(milliseconds: 1300),
      child: MaterialButton(
          padding: EdgeInsets.all(paddingValue),
          shape: CircleBorder(side: BorderSide.none),
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              if (utils.isDecimal(_input)) {
                if (utils.isNumberGreatherThan(_input + value, 9999999.99) ||
                    (utils.checkDecimalsFromString(_input + value, 2)))
                  _input = _input;
                else {
                  _input += value;
                }
              } else {
                _input += value;
              }
            });
          },
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
            ),
          )),
    ));
  }

  Widget _drawTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FadeInLeft(
          duration: Duration(milliseconds: 1200),
          child: Text(
            'DIGITE EL VALOR',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
