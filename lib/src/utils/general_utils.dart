import 'package:animate_do/animate_do.dart';
import 'package:hive/hive.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mpos/src/utils/entitycard_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

bool isNumeric(String value) {
  bool isNumeric;
  try {
    if (value.isEmpty) return false;
    final n = int.tryParse(value);
    isNumeric = n == null ? false : true;
  } catch (error) {
    isNumeric = false;
  }
  return isNumeric;
}

bool isDecimal(String value) {
  bool isDecimal;
  try {
    if (value.isEmpty) return false;
    final n = double.tryParse(value);
    isDecimal = n == null ? false : true;
  } catch (error) {
    isDecimal = false;
  }
  return isDecimal;
}

bool isNumberGreatherThan(String value, double maxValue) {
  bool isGreather = false;
  try {
    if (value.isEmpty) return false;
    final n = double.tryParse(value);
    if (n == null)
      isGreather = false;
    else {
      if (n > maxValue) isGreather = true;
    }
  } catch (error) {
    isGreather = false;
  }
  return isGreather;
}

bool checkDecimalsFromString(String value, int cantDecimals) {
  bool checkDecimal = false;
  try {
    if (value.isEmpty) return false;
    int len = value.substring(value.indexOf(".")).length;
    checkDecimal = len > 3 ? true : false;
  } catch (error) {
    checkDecimal = false;
  }
  return checkDecimal;
}

Widget sizedBoxSeparator() {
  return SizedBox(
    height: 5.0,
    child: new Center(
      child: new Container(
        margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
        height: 0.3,
        color: Colors.black,
      ),
    ),
  );
}

PreferredSizeWidget drawAppBar(String title, bool allowLeading) {
  return AppBar(
    automaticallyImplyLeading: allowLeading,
    elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
    title: Padding(
      padding: EdgeInsets.only(right: 60.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 22.0),
        ),
      ),
    ),
  );
}

Widget drawAppBarContainer(BuildContext context, String title) {
  return SafeArea(
    child: Center(
      child: Container(
        height: 65.0,
        color: Color.fromRGBO(110, 10, 0, 1.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BounceInLeft(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed('home'),
                  child: Icon(
                    Icons.home,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: FadeIn(
                  duration: Duration(milliseconds: 1000),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 15.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String dateParsed(DateTime date) {
  var formatedDate = DateFormat("dd-MM-yyyy HH:mm").format(date);
  return formatedDate;
}

limpiarDatosBloc(BuildContext context) {
  DatosTransaccionBloc blocTrn = Provider.datosTransaccionBloc(context);
  blocTrn.clear();
}

olvidoContrasenia() async {
  ParametroDatabase paramDb = new ParametroDatabase();
  Parametro urlAdminWeb = await paramDb.getParametro(3);
  final url = urlAdminWeb.valor +
      '/passwordrecover.aspx?eCsewqIXdoCdjNUp5P5jB7/xRV7R0rMcomirZpAAI40=';
  launch(url);
}

EntityCard obtenerIconoTarjeta(String tarjetaNombre) {
  EntityCard iconoTarjeta = new EntityCard();
  switch (tarjetaNombre) {
    case "MASTERCARD":
      iconoTarjeta.setCardPathImage("assets/cards/mastercard.png");
      iconoTarjeta.setSizeOfImage(26);
      break;
    case "VISA":
      iconoTarjeta.setCardPathImage("assets/cards/visa.png");
      iconoTarjeta.setSizeOfImage(14);
      break;
    case "DINERS":
      iconoTarjeta.setCardPathImage("assets/cards/diners.png");
      iconoTarjeta.setSizeOfImage(45);
      break;
    case "AMEX":
      iconoTarjeta.setCardPathImage("assets/cards/amex.png");
      iconoTarjeta.setSizeOfImage(22);
      break;
    case "TARJETA D":
      iconoTarjeta.setCardPathImage("assets/cards/tarjetad.png");
      iconoTarjeta.setSizeOfImage(26);
      break;
    case "OCA":
      iconoTarjeta.setCardPathImage("assets/cards/oca.png");
      iconoTarjeta.setSizeOfImage(10);
      break;
    case "CABAL":
      iconoTarjeta.setCardPathImage("assets/cards/cabal.png");
      iconoTarjeta.setSizeOfImage(7);
      break;
    case "ANDA":
      iconoTarjeta.setCardPathImage("assets/cards/anda.png");
      iconoTarjeta.setSizeOfImage(18);
      break;
    case "CREDITEL":
      iconoTarjeta.setCardPathImage("assets/cards/creditel.png");
      iconoTarjeta.setSizeOfImage(20);
      break;
    case "PASSCARD":
      iconoTarjeta.setCardPathImage("assets/cards/passcard.png");
      iconoTarjeta.setSizeOfImage(15);
      break;
    case "LIDER":
      iconoTarjeta.setCardPathImage("assets/cards/lider.png");
      iconoTarjeta.setSizeOfImage(15);
      break;
    case "CLUB DEL ESTE":
      iconoTarjeta.setCardPathImage("assets/cards/clubdeleste.png");
      iconoTarjeta.setSizeOfImage(20);
      break;
    case "MAESTRO":
      iconoTarjeta.setCardPathImage("assets/cards/maestro.png");
      iconoTarjeta.setSizeOfImage(22);
      break;
    case "EDENRED":
      iconoTarjeta.setCardPathImage("assets/cards/edenred.png");
      iconoTarjeta.setSizeOfImage(25);
      break;
    case "SODEXO":
      iconoTarjeta.setCardPathImage("assets/cards/sodexo.png");
      iconoTarjeta.setSizeOfImage(13);
      break;
    case "MI DINERO":
      iconoTarjeta.setCardPathImage("assets/cards/midinero.png");
      iconoTarjeta.setSizeOfImage(15);
      break;
    case "MIDES":
      iconoTarjeta.setCardPathImage("assets/cards/mides.png");
      iconoTarjeta.setSizeOfImage(22);
      break;
    case "BLANICO":
      iconoTarjeta.setCardPathImage("assets/cards/nothing.png");
      iconoTarjeta.setSizeOfImage(10);
      break;
    case "FIDELY":
      iconoTarjeta.setCardPathImage("assets/cards/nothing.png");
      iconoTarjeta.setSizeOfImage(10);
      break;
    case "GIFTCARD FD":
      iconoTarjeta.setCardPathImage("assets/cards/nothing.png");
      iconoTarjeta.setSizeOfImage(10);
      break;
    case "DUCSA":
      iconoTarjeta.setCardPathImage("assets/cards/nothing.png");
      iconoTarjeta.setSizeOfImage(10);
      break;
    case "TAXFREE":
      iconoTarjeta.setCardPathImage("assets/cards/nothing.png");
      iconoTarjeta.setSizeOfImage(10);
      break;
    case "MERCADO PAGO":
      iconoTarjeta.setCardPathImage("assets/cards/mercadopago.png");
      iconoTarjeta.setSizeOfImage(25);
      break;
    default:
      iconoTarjeta.setCardPathImage("assets/cards/nothing.png");
      iconoTarjeta.setSizeOfImage(10);
      break;
  }
  return iconoTarjeta;
}

String obtenerNombreProcesador(int tarjetaId) {
  String tarjetaNombre = "";
  switch (tarjetaId) {
    case 1:
      tarjetaNombre = "MASTERCARD";
      break;
    case 2:
      tarjetaNombre = "VISA";
      break;
    case 3:
      tarjetaNombre = "DINERS";
      break;
    case 4:
      tarjetaNombre = "AMEX";
      break;
    case 5:
      tarjetaNombre = "TARJETA D";
      break;
    case 6:
      tarjetaNombre = "OCA";
      break;
    case 8:
      tarjetaNombre = "CABAL";
      break;
    case 9:
      tarjetaNombre = "ANDA";
      break;
    case 12:
      tarjetaNombre = "CREDITEL";
      break;
    case 14:
      tarjetaNombre = "PASSCARD";
      break;
    case 15:
      tarjetaNombre = "LIDER";
      break;
    case 16:
      tarjetaNombre = "CLUB DEL ESTE";
      break;
    case 17:
      tarjetaNombre = "MAESTRO";
      break;
    case 19:
      tarjetaNombre = "EDENRED";
      break;
    case 20:
      tarjetaNombre = "SODEXO";
      break;
    case 21:
      tarjetaNombre = "MI DINERO";
      break;
    case 22:
      tarjetaNombre = "MIDES";
      break;
    case 23:
      tarjetaNombre = "BLANICO";
      break;
    case 25:
      tarjetaNombre = "FIDELY";
      break;
    case 26:
      tarjetaNombre = "GIFTCARD FD";
      break;
    case 27:
      tarjetaNombre = "DUCSA";
      break;
    case 28:
      tarjetaNombre = "TAXFREE";
      break;
    case 29:
      tarjetaNombre = "MERCADO PAGO";
      break;
    default:
      tarjetaNombre = "DESCONOCIDO";
      break;
  }
  return tarjetaNombre;
}

Future<String> obtenerPathHive() async {
  String platformPath = "";
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await path_provider.getApplicationDocumentsDirectory();
      platformPath = directory.path;
    } else if (Platform.isWindows) {
      if (kIsWeb) {
        platformPath = "C://Users//danie";
      } else {
        final PathProviderWindows provider = PathProviderWindows();
        platformPath = (await provider.getTemporaryPath());
      }
    } else if (Platform.isLinux) {
      final directory = await path_provider.getTemporaryDirectory();
      platformPath = directory.path;
    }
    print("Resultado path:" + platformPath);
  } on HiveError {} catch (e) {}
  return platformPath;
}

bool isWeb() {
  return kIsWeb;
}

bool isAndroid(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.android;
}

bool isMobile(BuildContext context) {
  return (Theme.of(context).platform == TargetPlatform.android ||
      Theme.of(context).platform == TargetPlatform.iOS);
}

bool isLinuxDesktop() {
  if (kIsWeb)
    return false;
  else {
    if (Platform.isLinux) {
      if (kIsWeb)
        return false;
      else
        return true;
    } else
      return false;
  }
}

bool isMacOSDesktop() {
  if (kIsWeb)
    return false;
  else {
    if (Platform.isMacOS) {
      if (kIsWeb)
        return false;
      else
        return true;
    } else
      return false;
  }
}

bool isWindowsDesktop() {
  if (kIsWeb)
    return false;
  else {
    if (Platform.isWindows) {
      if (kIsWeb)
        return false;
      else
        return true;
    } else
      return false;
  }
}

bool isLinux() {
  if (Platform.isLinux) {
    return true;
  } else
    return false;
}

bool isMacOS() {
  if (Platform.isMacOS) {
    return true;
  } else
    return false;
}

bool isWindows() {
  if (Platform.isWindows) {
    return true;
  } else
    return false;
}

bool isWebOrDesktop() {
  return isWeb() ||
      (isLinuxDesktop() || isWindowsDesktop() || isMacOSDesktop());
}

class GoHomeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Icon(
        Icons.home,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
