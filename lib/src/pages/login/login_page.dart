import 'package:flutter/material.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/logic/initialize_logic.dart' as initialize_logic;
import 'package:mpos/src/logic/auth_login_logic.dart' as login_logic;
import 'package:animate_do/animate_do.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController _userLoginEmailController = new TextEditingController();
  TextEditingController _userLoginPasswordController =
      new TextEditingController();
  FocusNode _userLoginPasswordFocus = new FocusNode();

  @override
  void initState() {
    initialize_logic.inicializar(context);
    login_logic.authLogin(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.loginBloc(context);

    if (bloc != null) {
      if (bloc.empresa != null) {
        if (bloc.empresa.usuarioLogueado != null &&
            bloc.empresa.usuarioLogueado.isNotEmpty) {
          _userLoginEmailController.text = bloc.empresa.usuarioLogueado;
        }
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        color: const Color(0x0CB6B1B1),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              BounceInDown(
                delay: Duration(milliseconds: 1200),
                child: Container(
                  width: (utils.isWeb() || utils.isWindowsDesktop())
                      ? width * 0.5
                      : width / 2,
                  height: height * 0.2,
                  child: Image.asset(
                    'assets/images/fondo.png',
                    fit: (utils.isWeb() || utils.isWindowsDesktop())
                        ? BoxFit.scaleDown
                        : BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              FadeIn(
                delay: Duration(milliseconds: 1600),
                duration: Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            RichText(
                                text: new TextSpan(
                                    style: new TextStyle(
                                      height: 1.0,
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                  new TextSpan(
                                    text: "mPOS",
                                    style: TextStyle(
                                        color: Color.fromRGBO(110, 10, 0, 1.0),
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Tahoma"),
                                  ),
                                ])),
                            RichText(
                                text: TextSpan(
                                    style: new TextStyle(
                                        height: 1.0,
                                        fontSize: 18.0,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                  new TextSpan(
                                      text: 'New Age Data',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          height: 1.0,
                                          fontSize: 16,
                                          color: Color.fromRGBO(
                                              191, 44, 55, 0.9))),
                                ]))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              _createEmail(bloc, width),
              SizedBox(
                height: 5.0,
              ),
              _createPassword(bloc, width),
              SizedBox(height: utils.isMobile(context) ? 10 : 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.fingerprint,
                        size: 55,
                        color: Color.fromRGBO(110, 10, 0, 1.0),
                      ),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.white70,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0))),
                      onPressed: () {
                        bloc.changeEmail("");
                        bloc.changePassword("");
                        login_logic.login(context, bloc);
                      },
                    ),
                  ),
                  SizedBox(height: utils.isMobile(context) ? 10 : 40),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.login_rounded,
                          size: 55, color: Color.fromRGBO(110, 10, 0, 1.0)),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.white70,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0))),
                      onPressed: () {
                        bloc.changeEmail(_userLoginEmailController.text.trim());
                        bloc.changePassword(_userLoginPasswordController.text);
                        login_logic.login(context, bloc);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: utils.isMobile(context) ? 15 : 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'register');
                },
                child: Text.rich(
                  TextSpan(text: '¿No dispones de una cuenta? ', children: [
                    TextSpan(
                      text: 'Registrarse',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Color.fromRGBO(110, 10, 0, 1.0),
                          fontWeight: FontWeight.w900),
                    ),
                  ]),
                ),
              ),
              SizedBox(height: utils.isMobile(context) ? 10 : 30),
              GestureDetector(
                onTap: () {
                  utils.olvidoContrasenia();
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Recuperar contraseña',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromRGBO(110, 10, 0, 1.0),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }

  Widget _createEmail(LoginBloc bloc, double width) {
    if (width > 1000) width = width / 1.3;
    width = (utils.isWeb() || utils.isWindowsDesktop()) ? width * 0.4 : width;
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: _userLoginEmailController,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: true,
              enableInteractiveSelection: true,
              onEditingComplete: () {
                if (_userLoginPasswordFocus.canRequestFocus)
                  _userLoginPasswordFocus.requestFocus();
              },
              decoration: InputDecoration(
                hintText: 'Email',
                suffixIcon: Icon(
                  Icons.alternate_email,
                  color: Color.fromRGBO(110, 10, 0, 1.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ));
      },
    );
  }

  Widget _createPassword(LoginBloc bloc, double width) {
    if (width > 1000) width = width / 1.3;
    width = (utils.isWeb() || utils.isWindowsDesktop()) ? width * 0.4 : width;
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                focusNode: _userLoginPasswordFocus,
                controller: _userLoginPasswordController,
                obscureText: true,
                onEditingComplete: () {
                  bloc.changeEmail(_userLoginEmailController.text);
                  bloc.changePassword(_userLoginPasswordController.text);
                  login_logic.login(context, bloc);
                },
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  suffixIcon: Icon(Icons.lock_open_outlined,
                      color: Color.fromRGBO(110, 10, 0, 1.0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ));
        });
  }
}
