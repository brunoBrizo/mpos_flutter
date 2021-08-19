import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mpos/src/database/cierre_lote_database.dart';
import 'package:mpos/src/modelo/cierre_lote_modelo.dart';
import 'package:mpos/src/pages/cierre_lote/cierre_lote_detail_page.dart';
import 'package:mpos/src/styles/title_styles.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/utils/general_utils.dart';

class CierreLotePage extends StatefulWidget {
  const CierreLotePage({Key key}) : super(key: key);

  @override
  _CierreLotePageState createState() => _CierreLotePageState();
}

class _CierreLotePageState extends State<CierreLotePage> {
  CierreLoteDatabase cierreDb = new CierreLoteDatabase();
  Box cierreBox;

  @override
  void initState() {
    super.initState();
    _inicializarCierreBox();
  }

  _inicializarCierreBox() async {
    try {
      cierreBox = await cierreDb.initCierreLote();
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
      await cierreDb.dispose();
    } catch (error) {}
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: utils.GoHomeIcon(),
      appBar: utils.drawAppBar('Cierres de Lote', true),
      body: _buildListView(context),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        drawAppBarContainer(context, 'Cierres de Lote'),
        Expanded(
          child: _buildListView(context),
        )
      ],
    );
  }

  _buildListView(BuildContext context) {
    return FutureBuilder(
      future: cierreDb.initCierreLote(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          EasyLoading.showError(snapshot.error.toString());
          Navigator.popAndPushNamed(context, 'home');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            Box cierreBox = snapshot.data;

            if (cierreBox.length == 0) {
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
              valueListenable: cierreBox.listenable(),
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

  Widget _drawList(BuildContext context, Box cierreBox) {
    List<CierreLote> lstCierre = cierreBox.values.toList().cast<CierreLote>();
    lstCierre.sort((a, b) => -a.fecha.compareTo(b.fecha));

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        shrinkWrap: true,
        itemCount: lstCierre.length,
        itemBuilder: (context, index) {
          CierreLote tempCierre = lstCierre[index];
          return FadeIn(
            duration: Duration(milliseconds: 800),
            child: Card(
              elevation: 7.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              shadowColor: Colors.black,
              child: _drawListTile(tempCierre, index),
            ),
          );
        });
  }

  Widget _drawListTile(CierreLote tempCierre, int index) {
    return ListTile(
        onTap: () {
          _verCierreDetail(tempCierre);
        },
        title: BounceInDown(
          duration: Duration(milliseconds: 800),
          from: 12,
          child: Text('Cierre Nro. #' + tempCierre.id.toString().trim(),
              style: TextStyle(
                  color: Color.fromRGBO(110, 10, 0, 1.0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        subtitle: BounceInUp(
            delay: Duration(milliseconds: 800),
            from: 12,
            child: Text(utils.dateParsed(tempCierre.fecha))),
        leading: BounceInLeft(
          delay: Duration(milliseconds: 800),
          from: 12,
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(110, 10, 0, 1.0),
            child: Text(
              tempCierre.id.toString(),
              style: TitleStyles.titleLarge,
            ),
          ),
        ),
        trailing: JelloIn(
          delay: Duration(milliseconds: 1300),
          child: IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              color: Color.fromRGBO(110, 10, 0, 1.0),
              onPressed: () {
                _verCierreDetail(tempCierre);
              }),
        ));
  }

  _verCierreDetail(CierreLote tempCierre) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CierreLoteDetail(tempCierre.id)));
  }
}
