import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mpos/src/database/transaccion_database.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';
import 'package:mpos/src/pages/sidebar/sidebar_page.dart';
import 'package:mpos/src/pages/ticket/ticket_detail.dart';
import 'package:mpos/src/styles/title_styles.dart';
import 'package:mpos/src/utils/entitycard_utils.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/utils/general_utils.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key key}) : super(key: key);

  @override
  _TicketListState createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  TransaccionDatabase trnDb = new TransaccionDatabase();
  Box trnBox;

  @override
  void initState() {
    super.initState();
    _inicializarTrnBox();
  }

  _inicializarTrnBox() async {
    try {
      trnBox = await trnDb.initTrn();
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  @override
  void dispose() async {
    try {
      super.dispose();
      await trnDb.dispose();
    } catch (error) {}
  }

/*
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          utils.limpiarDatosBloc(context);
          Navigator.popAndPushNamed(context, 'home');
          return false;
        },
        child: Scaffold(
          drawer: SideBar.drawSideBar(context),
          appBar: utils.drawAppBar('Lista de Tickets', true),
          body: _buildListView(context),
        ));
  } */

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          utils.limpiarDatosBloc(context);
          Navigator.popAndPushNamed(context, 'home');
          return false;
        },
        child: Column(
          children: [
            drawAppBarContainer(context, 'Lista de Tickets'),
            Expanded(
              child: _buildListView(context),
            )
          ],
        ));
  }

  _buildListView(BuildContext context) {
    return FutureBuilder(
      future: trnDb.initTrn(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          EasyLoading.showError(snapshot.error.toString());
          Navigator.popAndPushNamed(context, 'home');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            Box trnBox = snapshot.data;

            if (trnBox.length == 0) {
              return Column(
                children: [
                  SizedBox(
                    height: 45.0,
                  ),
                  Center(
                      child: Text(
                    'No hay registros',
                    style: TitleStyles.titleLarge,
                  ))
                ],
              );
            }

            return ValueListenableBuilder(
              valueListenable: trnBox.listenable(),
              builder: (BuildContext context, Box box, _) {
                return _drawList(context, box);
              },
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

  Widget _drawList(BuildContext context, Box trnBox) {
    List<Transaccion> lstTrn = trnBox.values.toList().cast<Transaccion>();
    lstTrn.sort((a, b) => -a.fecha.compareTo(b.fecha));

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        shrinkWrap: true,
        itemCount: lstTrn.length,
        itemBuilder: (context, index) {
          Transaccion tempTrn = lstTrn[index];
          return FadeIn(
            duration: Duration(milliseconds: 800),
            child: Card(
              elevation: 7.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              shadowColor: Colors.black,
              child: _drawListTile(tempTrn, index),
            ),
          );
        });
  }

  Widget _drawListTile(Transaccion tempTrn, int index) {
    String leadingText = (tempTrn.tipo == TipoTransaccion.Venta ? 'V' : 'D');
    EntityCard cardImage = utils.obtenerIconoTarjeta(tempTrn.tarjetaNombre);
    return ListTile(
      onTap: () {
        _verTicketDetail(tempTrn);
      },
      title: BounceInDown(
        delay: Duration(milliseconds: 800),
        from: 12,
        child: Text(
            ((tempTrn.tipo == TipoTransaccion.Venta ? '' : '-') +
                (tempTrn.moneda.value == 1 ? "\$" : "U\$") +
                tempTrn.monto.toString()),
            style: TextStyle(
                color: Color.fromRGBO(110, 10, 0, 1.0),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BounceInUp(
              delay: Duration(milliseconds: 800),
              from: 12,
              child: Text(utils.dateParsed(tempTrn.fecha))),
          Spacer(),
          BounceInLeft(
            delay: Duration(milliseconds: 800),
            from: 15,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Text('#' + tempTrn.ticket.toString().trim(),
                  style: TextStyle(
                      color: Color.fromRGBO(110, 10, 0, 1.0),
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      leading: BounceInLeft(
        delay: Duration(milliseconds: 800),
        from: 12,
        child: CircleAvatar(
          backgroundColor: Color.fromRGBO(110, 10, 0, 1.0),
          child: Text(
            leadingText,
            style: TitleStyles.titleLarge,
          ),
        ),
      ),
      trailing: JelloIn(
        delay: Duration(milliseconds: 1500),
        child: Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Image.asset(
            cardImage.getCardPathImage(),
            fit: BoxFit.fill,
            height: cardImage.getSizeOfImage(),
          ),
        ),
      ),
    );
  }

  _verTicketDetail(Transaccion tempTrn) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TicketDetail(tempTrn.id)));
  }
}
