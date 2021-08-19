import 'package:flutter/material.dart';
import 'package:mpos/src/pages/login/login_page.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 5200), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 400,
              width: 400,
              child: Lottie.asset("assets/images/credit-card.json")),
          SizedBox(
            height: 20,
          ),
          Text(
            "mPOS",
            style: TextStyle(
                color: Color.fromRGBO(110, 10, 0, 1.0),
                fontSize: 45,
                fontWeight: FontWeight.bold,
                fontFamily: "Tahoma"),
          ),
        ],
      ),
    ));
  }
}
