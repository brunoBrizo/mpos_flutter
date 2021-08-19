import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';

String ensamblarXMLTransaccion(DatosTransaccionBloc bloc) {
  String tipoTrn =
      bloc.tipoTransaccion == TipoTransaccion.Venta ? 'VTA' : 'DEV';
  String xmlTransaccionWS =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tran="http://schemas.datacontract.org/2004/07/TransActV4ConcentradorWS.TransActV4Concentrador">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:PostearTransaccion>
         <tem:Transaccion>
            <tran:EmpCod>''' +
          bloc.empCod +
          '''</tran:EmpCod>
            <tran:EmpHASH>''' +
          bloc.empHash +
          '''</tran:EmpHASH>
          <tran:Extendida>
               <tran:Cuotas>''' +
          bloc.cuotas.toString() +
          '''</tran:Cuotas>
          </tran:Extendida>
            <tran:FacturaConsumidorFinal>''' +
          bloc.consumidorFinal.toString() +
          '''</tran:FacturaConsumidorFinal>
            <tran:FacturaMonto>''' +
          (bloc.importeFactura * 100).toString() +
          '''</tran:FacturaMonto>
            <tran:FacturaMontoGravado>''' +
          (bloc.importeGravado * 100).toString() +
          '''</tran:FacturaMontoGravado>
            <tran:FacturaNro>''' +
          bloc.numFactura.toString() +
          '''</tran:FacturaNro>
            <tran:MonedaISO>''' +
          (bloc.moneda == 2 ? "0840" : "0858") +
          '''</tran:MonedaISO>
            <tran:Monto>''' +
          (bloc.importe * 100).toString() +
          '''</tran:Monto>
            <tran:Operacion>''' +
          tipoTrn +
          '''</tran:Operacion>
            <tran:TermCod>''' +
          bloc.termCod +
          '''</tran:TermCod>
          <tran:TicketOriginal>''' +
          bloc.ticketOriginal.toString() +
          '''</tran:TicketOriginal>
         </tem:Transaccion>
      </tem:PostearTransaccion>
   </soapenv:Body>
</soapenv:Envelope>''';

  return xmlTransaccionWS;
}

String ensamblarXMLConsultarTransaccion(String tokenNro) {
  String xmlTransaccionWS =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:ConsultarTransaccion>
         <tem:TokenNro>''' +
          tokenNro +
          '''</tem:TokenNro>
      </tem:ConsultarTransaccion>
   </soapenv:Body>
</soapenv:Envelope>''';

  return xmlTransaccionWS;
}

String ensamblarXMLCierreLote(Empresa empresa) {
  String xmlCierreLoteWS =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tran="http://schemas.datacontract.org/2004/07/TransActV4ConcentradorWS.TransActV4Concentrador">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:PostearCierre>
         <tem:Cierre>
            <tran:CierreCentralizado>''' +
          "0" +
          '''</tran:CierreCentralizado>
            <tran:EmpCod>''' +
          empresa.codigo +
          '''</tran:EmpCod>
            <tran:EmpHASH>''' +
          empresa.hash +
          '''</tran:EmpHASH>
            <tran:MultiEmp>''' +
          "0" +
          '''</tran:MultiEmp>
            <tran:TermCod>''' +
          empresa.codigoTerminal +
          '''</tran:TermCod>
         </tem:Cierre>
      </tem:PostearCierre>
   </soapenv:Body>
</soapenv:Envelope>''';

  return xmlCierreLoteWS;
}

String ensamblarXMLConsultarCierreLote(String tokenNro) {
  String xmlCierreLotenWS =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:ConsultarCierre>
         <tem:TokenNro>''' +
          tokenNro +
          '''</tem:TokenNro>
      </tem:ConsultarCierre>
   </soapenv:Body>
</soapenv:Envelope>''';
  return xmlCierreLotenWS;
}

String ensamblarXMLLogin(String authorization) {
  String xmlLoginWS =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:t4w="T4WebKB">
   <soapenv:Header/>
   <soapenv:Body>
      <t4w:Services.WSMPOSLogin.Execute>
         <t4w:Authorization>''' +
          authorization +
          '''</t4w:Authorization>
      </t4w:Services.WSMPOSLogin.Execute>
   </soapenv:Body>
</soapenv:Envelope>''';
  return xmlLoginWS;
}

String ensamblarXMLAsociarTerminal(Empresa emp) {
  String xmlLoginWS =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:t4w="T4WebKB" xmlns:tran="TransActWebT4WebKB">
   <soapenv:Header/>
   <soapenv:Body>
      <t4w:Services.WSMPOSAsociarTerminal.Execute>
         <t4w:Mposasocterrequest>
            <tran:EmpID>''' +
          emp.id.toString() +
          '''</tran:EmpID>
            <tran:TerCod>''' +
          emp.codigoTerminal +
          '''</tran:TerCod>
            <tran:Token>''' +
          emp.token +
          '''</tran:Token>
         </t4w:Mposasocterrequest>
      </t4w:Services.WSMPOSAsociarTerminal.Execute>
   </soapenv:Body>
</soapenv:Envelope>''';

  return xmlLoginWS;
}
