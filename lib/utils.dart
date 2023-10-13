//Para imprimir mensaje en el ScackBar
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

printMsg(msg, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.info,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(msg),
        ],
      ),
      backgroundColor: Colors.red.withOpacity(0.8),
      padding: EdgeInsets.all(19.0),
      duration: Duration(milliseconds: 800),
    ),
  );
}

late SharedPreferences prefs;
bool isDolar = true;
double dolarvalue = 1;

cargarDolar() async {
  // Obtain shared preferences.
  prefs = await SharedPreferences.getInstance();
  isDolar = await prefs.getBool('dolar')!;
  dolarvalue = await prefs.getDouble('dolarvalue')!;
}

String dolarBs(double dolares) {
  String stringValue = isDolar
      ? "${dolares.toStringAsFixed(2)} \$"
      : "${(dolares *= dolarvalue).toStringAsFixed(2)} Bs";
  //print("$dolares x $dolarvalue = $stringValue");
  return stringValue;
}

String inBs(double dolares) {
  String stringValue = "${(dolares *= dolarvalue).toStringAsFixed(2)} Bs";
  return stringValue;
}

const List<String> listType = <String>['Uno', 'Dos', 'Tres', 'Cuatro'];

String dropdownValue = listType.first;
