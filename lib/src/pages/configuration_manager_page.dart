import 'package:flutter/material.dart';
import 'package:mpos/src/pages/configuration_page.dart';
import 'package:mpos/src/pages/information_page.dart';

class ConfigurationManagerPage extends StatefulWidget {
  @override
  _ConfigurationManagerPageState createState() =>
      _ConfigurationManagerPageState();
}

class _ConfigurationManagerPageState extends State<ConfigurationManagerPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [ConfigurationPage(), InformationPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(47, 47, 47, 0.1),
        selectedItemColor: Color.fromRGBO(110, 10, 0, 1.0),
        unselectedItemColor: Color.fromRGBO(47, 47, 47, 1),
        iconSize: 28.0,
        selectedFontSize: 14.5,
        unselectedFontSize: 12.0,
        currentIndex: _currentIndex,
        onTap: _onTappedBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Configuración",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "Información",
          )
        ],
      ),
    );
  }

  _onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
