import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mpos/src/database/transaccion_database.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';
import 'package:mpos/src/pages/sidebar/sidebar_page.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/styles/title_styles.dart';
import 'package:intl/intl.dart';

class ChartComponent extends StatefulWidget {
  @override
  _ChartComponentState createState() => _ChartComponentState();
}

class _ChartComponentState extends State<ChartComponent> {
  bool showAsPercentage;

  static final List<Color> colorList = [
    Colors.amber,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.black45,
    Colors.cyan,
    Colors.lime,
    Colors.teal,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    showAsPercentage = false;
    _getTransactionsCurrentDay();
  }
/*
  @override
  Widget build(BuildContext context) {
    return utils.isMobile(context)
        ? SafeArea(
            child: Scaffold(
              drawer: SideBar.drawSideBar(context),
              appBar: utils.drawAppBar('Reportes', true),
              body: FutureBuilder<Map<String, double>>(
                  future: _getTransactionsCurrentDay(),
                  initialData: Map<String, double>(),
                  builder: (
                    context,
                    snapshot,
                  ) {
                    return _drawBody(context, snapshot.requireData);
                  }),
            ),
          )
        : Scaffold(
            drawer: SideBar.drawSideBar(context),
            appBar: utils.drawAppBar('Reportes', true),
            body: FutureBuilder<Map<String, double>>(
                future: _getTransactionsCurrentDay(),
                initialData: Map<String, double>(),
                builder: (
                  context,
                  snapshot,
                ) {
                  return _drawBody(context, snapshot.requireData);
                }),
          );
  }*/

  @override
  Widget build(BuildContext context) {
    return utils.isMobile(context)
        ? SafeArea(
            child: Column(
              children: [
                utils.drawAppBarContainer(context, 'Reportes'),
                Expanded(
                  child: FutureBuilder<Map<String, double>>(
                      future: _getTransactionsCurrentDay(),
                      initialData: Map<String, double>(),
                      builder: (
                        context,
                        snapshot,
                      ) {
                        return _drawBody(context, snapshot.requireData);
                      }),
                )
              ],
            ),
          )
        : Scaffold(
            drawer: SideBar.drawSideBar(context),
            appBar: utils.drawAppBar('Reportes', true),
            body: FutureBuilder<Map<String, double>>(
                future: _getTransactionsCurrentDay(),
                initialData: Map<String, double>(),
                builder: (
                  context,
                  snapshot,
                ) {
                  return _drawBody(context, snapshot.requireData);
                }),
          );
  }

  _drawBody(BuildContext context, Map<String, double> dataMap) {
    return Stack(children: [
      Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Text("Ventas: " + DateFormat('yyyy-MM-dd').format(DateTime.now()),
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Radio(
              value: false,
              groupValue: showAsPercentage,
              onChanged: (val) {
                setState(() {
                  showAsPercentage = val;
                });
              },
            ),
            Text(
              'Monto',
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
            Radio(
              value: true,
              groupValue: showAsPercentage,
              onChanged: (val) {
                setState(() {
                  showAsPercentage = val;
                });
              },
            ),
            Text(
              'Porciento',
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          dataMap.entries.length <= 0
              ? Center(
                  child: Container(
                    child: Text("No hay ventas registradas",
                        style: TitleStyles.titleMedium),
                  ),
                )
              : Center(
                  child: Container(
                      child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 30,
                    chartRadius: MediaQuery.of(context).size.width / 1.2,
                    colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 30,
                    centerText: "",
                    legendOptions: LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: showAsPercentage,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  )),
                )
        ],
      ),
    ]);
  }

  Future<Map<String, double>> _getTransactionsCurrentDay() async {
    Map<String, double> dataMapTmp = {};
    TransaccionDatabase trnDb = new TransaccionDatabase();
    List<Transaccion> trnList = await trnDb.getAllTrn(DateTime.now());
    if (trnList.isNotEmpty) {
      for (var item in trnList) {
        String keyMap = utils.obtenerNombreProcesador(item.tarjetaId);
        double valueMap = item.monto;
        if (dataMapTmp.containsKey(keyMap)) {
          dataMapTmp.update(keyMap, (value) => value + valueMap);
        } else {
          Map<String, double> tmp = {keyMap: valueMap};
          dataMapTmp.addAll(tmp);
        }
      }
    }
    return dataMapTmp;
  }
}
