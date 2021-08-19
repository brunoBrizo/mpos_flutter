import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/database/transaccion_database.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/logic/ticket_logic.dart' as ticket_logic;

class TicketDetail extends StatefulWidget {
  final int _ticketId;

  TicketDetail(this._ticketId);

  @override
  _TicketDetailState createState() => _TicketDetailState(_ticketId);
}

class _TicketDetailState extends State<TicketDetail> {
  final int _ticketId;
  _TicketDetailState(this._ticketId);
  TransaccionDatabase trnDb = new TransaccionDatabase();
  Transaccion trn;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.drawAppBar('Detalle de Ticket', true),
      body: _drawBody(context),
    );
  }

  Widget _drawBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: trnDb.getTrn(_ticketId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          EasyLoading.showError(snapshot.error.toString());
          Navigator.popAndPushNamed(context, 'ticket_list');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            trn = snapshot.data;
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FadeIn(
                    duration: Duration(milliseconds: 1000),
                    child: Container(
                      child: _drawFirstCard(trn),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FadeIn(
                    duration: Duration(milliseconds: 1100),
                    child: Container(
                      child: _drawSecondCard(trn),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _drawReenviar(size),
                        SizedBox(
                          width: 20.0,
                        ),
                        _drawDevolver(trn, size),
                      ],
                    ),
                  ),
                )
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

  Widget _drawFirstCard(Transaccion trn) {
    return Card(
      shadowColor: Colors.black,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _drawTrnNumero(),
            _drawTrnFecha(),
            _drawMonedaPrecio()
          ],
        ),
      ),
    );
  }

  _drawTrnNumero() {
    String tipoTrn = trn.tipo == TipoTransaccion.Venta ? 'Venta' : 'Devolucion';
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 10.0),
      child: Row(children: <Widget>[
        Text(
          tipoTrn + ' ' + trn.ticket.toString(),
          style: new TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(110, 10, 0, 1.0),
          ),
        ),
        Spacer(),
      ]),
    );
  }

  _drawTrnFecha() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0),
      child: Row(children: <Widget>[
        Text(utils.dateParsed(trn.fecha),
            style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400)),
        Spacer(),
      ]),
    );
  }

  _drawMonedaPrecio() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0, bottom: 10.0, left: 10.0, right: 10.0),
      child: Row(
        children: <Widget>[
          Text(
            trn.moneda.value == 2 ? 'U\$S' : '\$',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Text(
            trn.monto.toString(),
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _drawSecondCard(Transaccion trn) {
    return Card(
      shadowColor: Colors.black,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 10.0),
              child: Row(children: <Widget>[
                Text('Tarjeta \n' + trn.tarjetaNombre,
                    style: new TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(110, 10, 0, 1.0),
                    )),
              ]),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 10.0),
              child: Row(children: <Widget>[
                Text("Autorización " + trn.nroAutorizacion,
                    style: new TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.w400)),
                Spacer(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Cuotas: " + trn.cuotas.toString(),
                    style: new TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  ElasticInDown(
                    delay: Duration(milliseconds: 1200),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.credit_card_rounded,
                        color: Color.fromRGBO(110, 10, 0, 1.0),
                        size: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawReenviar(Size size) {
    return Expanded(
      child: BounceInLeft(
        delay: Duration(milliseconds: 800),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.5),
            child: ButtonTheme(
              height: size.height * 0.05,
              minWidth: size.width * 2.7,
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
                    ticket_logic.reenviar(context, _ticketId);
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawDevolver(Transaccion trn, Size size) {
    if (trn.tipo == TipoTransaccion.Devolucion) {
      return Container();
    }
    return Expanded(
      child: BounceInRight(
        delay: Duration(milliseconds: 800),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.5),
            child: ButtonTheme(
              height: size.height * 0.05,
              minWidth: size.width * 0.6,
              child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: size.height * 0.035,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      primary: Color.fromRGBO(110, 10, 0, 1.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  label: Text(
                    'Devolver',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (trn.fueDevuelto) {
                      EasyLoading.showError('El ticket ya fue devuelto');
                      return null;
                    }
                    ticket_logic.devolver(context, _ticketId);
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
