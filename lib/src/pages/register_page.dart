import 'package:flutter/material.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: SafeArea(
        child: new Scaffold(
          appBar: utils.drawAppBar('Registro', true),
          body: new Center(
            child: _drawBody(context),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, 'login');
        return true;
      },
    );
  }

  _drawBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  child: _drawRegisterCard(size),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              _drawButtonRegister(size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawRegisterCard(Size size) {
    return Card(
      shadowColor: Colors.black,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('¿No dispones de una cuenta?',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: new TextStyle(
                      fontSize: 25.0,
                      color: Color.fromRGBO(110, 10, 0, 1.0),
                    )),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
              child: Column(
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Text(
                        "Para iniciar el proceso de registro, es necesario completar los datos de: \n",
                        style: new TextStyle(fontSize: 17.0)),
                    Text("RUT",
                        style: new TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Text("Nombre y Apellidos",
                        style: new TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Text("Correo electrónico.",
                        style: new TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Text(
                        "\n\nSi cuenta con todos los datos, seleccione la " +
                            "opción Registrarse.\n",
                        style: new TextStyle(fontSize: 17.0)),
                    Text(
                        "Esta opción lo redireccionará al sitio web correspondiente para completar el proceso",
                        textAlign: TextAlign.start,
                        textDirection: TextDirection.ltr,
                        style: new TextStyle(fontSize: 17.0)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawButtonRegister(Size size) {
    return ButtonTheme(
      height: size.height * .05,
      child: ElevatedButton.icon(
          icon: Icon(
            Icons.app_registration,
            size: size.height * 0.035,
          ),
          style: ElevatedButton.styleFrom(
              elevation: 1,
              primary: Color.fromRGBO(110, 10, 0, 1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
          label: Text(
            'Registrarse',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            ParametroDatabase paramDb = new ParametroDatabase();
            Parametro urlAdminWeb = await paramDb.getParametro(3);
            final url = urlAdminWeb.valor + '/register.aspx';
            launch(url);
          }),
    );
  }
}
