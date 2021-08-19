import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/database/cierre_lote_database.dart';
import 'package:mpos/src/modelo/cierre_lote_modelo.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:share/share.dart';

class CierreLoteDetail extends StatefulWidget {
  final int _cierreLoteId;
  CierreLoteDetail(this._cierreLoteId);

  @override
  _CierreLoteDetailState createState() => _CierreLoteDetailState(_cierreLoteId);
}

class _CierreLoteDetailState extends State<CierreLoteDetail> {
  final int _cierreLoteId;
  _CierreLoteDetailState(this._cierreLoteId);
  CierreLoteDatabase cierreDb = new CierreLoteDatabase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.drawAppBar('Detalle de Cierre', true),
      body: _drawBody(context),
    );
  }

  Widget _drawBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: cierreDb.getCierreLote(_cierreLoteId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          EasyLoading.showError(snapshot.error.toString());
          Navigator.popAndPushNamed(context, 'cierre_lote');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            CierreLote cierre = snapshot.data;
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: _drawFirstCard(cierre),
                  ),
                ),
                _drawCompartir(context, cierre, size)
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      },
    );
  }

  Widget _drawFirstCard(CierreLote cierre) {
    final size = MediaQuery.of(context).size;
    return FadeIn(
      delay: Duration(milliseconds: 200),
      child: Card(
        shadowColor: Colors.black,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(children: <Widget>[
                  BounceInLeft(
                    delay: Duration(milliseconds: 800),
                    from: 15,
                    child: Text('Cierre Nro. ' + cierre.id.toString(),
                        style: TextStyle(
                            color: Color.fromRGBO(110, 10, 0, 1.0),
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                child: Row(children: <Widget>[
                  Text(utils.dateParsed(cierre.fecha),
                      style: new TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w400)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Estado: ',
                      style: new TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Text(
                      (cierre.estado.length > 12
                          ? cierre.estado.substring(0, 12) +
                              "\n" +
                              cierre.estado.substring(12)
                          : cierre.estado),
                      style: (cierre.estado.length > 12
                          ? TextStyle(fontSize: 12)
                          : TextStyle(fontSize: 24)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Usuario',
                  style: new TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BounceInUp(
                        delay: Duration(milliseconds: 800),
                        from: 15,
                        child: Container(
                          width: size.width * 0.75,
                          height: size.height * 0.07,
                          child: Center(
                            child: Text(
                              cierre.user.isEmpty
                                  ? "No encontrado"
                                  : cierre.user,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawCompartir(BuildContext context, CierreLote cierre, Size size) {
    return Expanded(
      child: BounceInUp(
        delay: Duration(milliseconds: 1000),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.5),
            child: ButtonTheme(
              height: size.height * 0.08,
              minWidth: size.width * 0.6,
              child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.share,
                    size: size.height * 0.035,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      primary: Color.fromRGBO(110, 10, 0, 1.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  label: Text(
                    'Compartir',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _compartirCierre(context, cierre);
                  }),
            ),
          ),
        ),
      ),
    );
  }

  _compartirCierre(BuildContext context, CierreLote cierre) async {
    final RenderBox renderBox = context.findRenderObject();
    String subject = 'Cierre Lote Nro. ' + cierre.id.toString();
    await Share.share(cierre.xmlRespuesta,
        subject: subject,
        sharePositionOrigin:
            renderBox.localToGlobal(Offset.zero) & renderBox.size);
  }
}
