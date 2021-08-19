import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/database/transaccion_database.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';
import 'package:share/share.dart';
import 'package:mpos/src/logic/voucherpdf_logic.dart' as voucherpdf_logic;

devolver(BuildContext context, int _ticketId) async {
  DatosTransaccionBloc blocTrn = Provider.datosTransaccionBloc(context);
  await cargarDatosTransaccionBloc(context, blocTrn, _ticketId);
  Navigator.pushNamed(context, 'ingreso_datos');
}

reenviar(BuildContext context, int _ticketId) async {
  try {
    TransaccionDatabase trnDb = new TransaccionDatabase();
    DatosTransaccionBloc blocTrn = Provider.datosTransaccionBloc(context);
    await cargarDatosTransaccionBloc(context, blocTrn, _ticketId);
    Transaccion trn = await trnDb.getTrn(_ticketId);
    String voucherResult = voucherpdf_logic.assemblyCustomerVoucherReShare(trn);
    String pathToPDF = await voucherpdf_logic.createPDFFile(voucherResult);
    String subject = "Factura mPOS NAD" +
        (blocTrn.numFactura == 0
            ? "."
            : " Nro. " + blocTrn.numFactura.toString());
    await Share.shareFiles(
      [pathToPDF],
      text: subject,
    );
  } on Exception catch (exception) {
    EasyLoading.showError("Error al compartir. " + exception.toString());
  } catch (error) {
    EasyLoading.showError("Error al compartir. " + error.toString());
  }
}

cargarDatosTransaccionBloc(
    BuildContext context, DatosTransaccionBloc blocTrn, int _ticketId) async {
  try {
    TransaccionDatabase trnDb = new TransaccionDatabase();
    Transaccion trn = await trnDb.getTrn(_ticketId);
    LoginBloc blocLogin = Provider.loginBloc(context);
    ParametroDatabase parametroDatabase = new ParametroDatabase();
    Parametro paramLogin = await parametroDatabase.getParametro(5);
    blocLogin.changeEmail(paramLogin.valor);

    blocTrn.changeTipoTransaccion(TipoTransaccion.Devolucion);
    blocTrn.changeTicketOriginal(trn.ticket);
    blocTrn.changeImporte(trn.facturaMonto);
    blocTrn.changeImporteFactura(trn.facturaMonto);
    blocTrn.changeImporteGravado(trn.facturaMontoGravado);
    blocTrn.changeCuotas(0);
    blocTrn.changeNumFactura(0);
    blocTrn.changeMoneda(trn.moneda.value);
    blocTrn.changeConsumidorFinal(true);
    EmpresaDatabase empDb = new EmpresaDatabase();
    Empresa emp = await empDb.getEmpresa(1);
    blocTrn.changeEmpCod(emp.codigo);
    blocTrn.changeTermCod(emp.codigoTerminal);
    blocTrn.changeEmpHashCod(emp.hash);
  } on Exception catch (exception) {
    EasyLoading.showError(exception.toString());
  } catch (error) {
    EasyLoading.showError(error.toString());
  }
}
