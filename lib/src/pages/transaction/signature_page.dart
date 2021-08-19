import 'dart:io';
import 'dart:typed_data';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({Key key}) : super(key: key);

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1.0,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: utils.drawAppBar('Firma digital', true),
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            //SIGNATURE
            Signature(
              controller: _controller,
              height: size.height * 0.79,
              backgroundColor: Colors.white,
            ),
            //botones de ok y limpiar
            Container(
              height: size.height * 0.1,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(110, 10, 0, 1.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 25.0,
                            ),
                            Text(
                              'Guardar',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (_controller.isNotEmpty) {
                            final Uint8List data =
                                await _controller.toPngBytes();
                            if (data != null) {
                              final directory =
                                  await getExternalStorageDirectory();
                              //print('directory: ' + directory.path);
                              if (directory != null) {
                                final myImagePath =
                                    directory.path + "/tmpSignature.png";
                                File imageFile = File(myImagePath);
                                if (!await imageFile.exists()) {
                                  imageFile.create(recursive: true);
                                }
                                await imageFile.writeAsBytes(data);
                                DatosTransaccionBloc bloc =
                                    Provider.datosTransaccionBloc(context);
                                bloc.changeSignaturePngPath(myImagePath);
                              }
                              Navigator.pushReplacementNamed(
                                  context, 'resumen');
                            }
                          } else {
                            await showEmptySignatureAlert(context);
                          }
                        },
                        autofocus: false,
                        clipBehavior: Clip.none,
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(110, 10, 0, 1.0)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 1.7))))),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                        child: Row(
                          children: [
                            Icon(
                              Icons.clear_sharp,
                              size: 25.0,
                            ),
                            Text(
                              'Limpiar',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() => _controller.clear());
                        },
                        autofocus: false,
                        clipBehavior: Clip.none,
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(110, 10, 0, 1.0)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 1.7))))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showEmptySignatureAlert(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'resumen');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Firma Digital"),
      content: Text("La firma digital está vacía. Desea continuar?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
