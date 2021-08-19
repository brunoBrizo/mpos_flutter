import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/components/chart_component.dart';
import 'package:mpos/src/pages/cierre_lote/cierre_lote_list_page.dart';
import 'package:mpos/src/pages/login/login_page.dart';
import 'package:mpos/src/pages/main_screen/menu_main_page.dart';
import 'package:mpos/src/pages/register_page.dart';
import 'package:mpos/src/pages/configuration_manager_page.dart';
import 'package:mpos/src/pages/splash/splash_page.dart';
import 'package:mpos/src/pages/ticket/ticket_list_page.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/pages/transaction/ingreso_importe_page.dart';
import 'package:mpos/src/pages/transaction/ingreso_datos_page.dart';
import 'package:mpos/src/pages/transaction/resumen_page.dart';
import 'package:mpos/src/logic/initialize_logic.dart' as initialize_logic;
import 'package:mpos/src/pages/transaction/signature_page.dart';
import 'package:mpos/src/utils/customanimation_utils.dart';
import 'package:responsive_framework/responsive_framework.dart';

void inicializarEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 3500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60.0
    ..radius = 75.0
    ..progressColor = Color.fromRGBO(110, 10, 0, 1.0)
    ..progressWidth = 5
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..backgroundColor = Colors.black87
    ..indicatorColor = Colors.red
    ..textColor = Colors.white
    ..maskColor = Colors.white.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true
    ..customAnimation = CustomAnimation();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  inicializarEasyLoading();
  await initialize_logic.inicializarHive();
  initialize_logic.inicializarSizeWindows();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mPOS NAD',
      initialRoute: 'login',
      home: HomePage(),
      builder: (context, child) {
        child = ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child),
            maxWidth: 2460,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: Colors.white));
        child = EasyLoading.init()(context, child);
        return child;
      },
      routes: {
        'splash': (BuildContext context) => SplashPage(),
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
        'ingreso_importe': (BuildContext context) => IngresoImportePage(),
        'cierre_lote': (BuildContext context) => CierreLotePage(),
        'ingreso_datos': (BuildContext context) => IngresoDatos(),
        'resumen': (BuildContext context) => Resumen(),
        'ticket_list': (BuildContext context) => TicketList(),
        'register': (BuildContext context) => Register(),
        'configuration_manager': (BuildContext context) =>
            ConfigurationManagerPage(),
        'signature': (BuildContext context) => SignaturePage(),
        'chart': (BuildContext context) => ChartComponent()
      },
      theme: ThemeData(
        primaryColorLight: Colors.white,
        primaryColor: Color.fromRGBO(110, 10, 0, 1.0),
      ),
    ));
  }
}
