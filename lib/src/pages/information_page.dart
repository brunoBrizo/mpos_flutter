import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/pages/sidebar/sidebar_page.dart';
import 'package:mpos/src/styles/title_styles.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  EmpresaDatabase empresaDb = new EmpresaDatabase();
  Box empresaBox;
  Empresa emp;

  @override
  void initState() {
    _getEmpresa();
    super.initState();
  }

  @override
  void dispose() async {
    try {
      super.dispose();
      await empresaDb.dispose();
    } catch (error) {}
  }

  _getEmpresa() async {
    //await empresaDb.createBaseEmpresa(); //solamente para testing
    try {
      empresaBox = await empresaDb.initEmpresa();
      emp = await empresaBox.get(1);
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          drawer: SideBar.drawSideBar(context),
          appBar: utils.drawAppBar('Información', true),
          body: FutureBuilder(
            future: empresaDb.initEmpresa(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                EasyLoading.showError(snapshot.error.toString());
                Navigator.popAndPushNamed(context, 'home');
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: <Widget>[
                              _drawFirstCard(size),
                              _drawSecondCard(size)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            },
          )),
    );
  }

  Widget _drawFirstCard(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 13.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 10.0),
          child: Column(
            children: <Widget>[
              _drawTextoEmpresa(size),
              _drawNombreEmpresa(),
              _drawRutEmpresa(),
              _drawRazonSocialEmpresa(),
              _drawCodigoEmpresa(),
              _drawEmpHashText(size),
              _drawTokenText(size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawSecondCard(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 13.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 10.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              _drawTextoTerminal(size),
              _drawCodigoTerminal(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawTextoEmpresa(Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
      child: Row(children: <Widget>[
        SizedBox(
          width: size.width * 0.31,
        ),
        Center(
          child: Text(
            'Empresa',
            style: TitleStyles.titleMedium,
          ),
        ),
      ]),
    );
  }

  Widget _drawNombreEmpresa() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Nombre',
                style: TitleStyles.titleSmall,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  emp.nombre,
                  style: TitleStyles.titleSmall,
                ),
              ),
            ),
          ]),
    );
  }

  Widget _drawRutEmpresa() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'RUT',
                style: TitleStyles.titleSmall,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  emp.rut,
                  style: TitleStyles.titleSmall,
                ),
              ),
            ),
          ]),
    );
  }

  Widget _drawRazonSocialEmpresa() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Razón Social',
                style: TitleStyles.titleSmall,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  emp.razonSocial,
                  style: TitleStyles.titleSmall,
                ),
              ),
            ),
          ]),
    );
  }

  Widget _drawCodigoEmpresa() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Código',
                style: TitleStyles.titleSmall,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  emp.codigo,
                  style: TitleStyles.titleSmall,
                ),
              ),
            ),
          ]),
    );
  }

  Widget _drawEmpHashText(Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(children: <Widget>[
        Text(
          'Hash',
          style: TitleStyles.titleSmall,
        ),
        SizedBox(
          width: size.height * 0.055,
        ),
        Container(
          width: size.width * 0.55,
          child: Center(
            child: Text(
              emp.hash,
              style: TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic),
            ),
          ),
        )
      ]),
    );
  }

  Widget _drawTokenText(Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(children: <Widget>[
        Text(
          'Token',
          style: TitleStyles.titleSmall,
        ),
        SizedBox(
          width: size.width * 0.05,
        ),
        Container(
          width: size.width * 0.6,
          child: Center(
            child: Text(
              emp.token,
              style: TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic),
            ),
          ),
        )
      ]),
    );
  }

  Widget _drawTextoTerminal(Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
      child: Row(children: <Widget>[
        SizedBox(
          width: size.width * 0.31,
        ),
        Center(
          child: Text(
            'Terminal',
            style: TitleStyles.titleMedium,
          ),
        ),
      ]),
    );
  }

  Widget _drawCodigoTerminal() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Código',
                style: TitleStyles.titleSmall,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  emp.codigoTerminal,
                  style: TitleStyles.titleSmall,
                ),
              ),
            ),
          ]),
    );
  }
}
