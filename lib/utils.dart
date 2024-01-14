//Para imprimir mensaje en el ScackBar
import 'package:comprame_inventory/Firebase/firestore.dart';
import 'package:comprame_inventory/models/dolar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

printMsg(msg, context, [error = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            error ? Icons.cancel_outlined : Icons.check_circle_outline,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(msg),
        ],
      ),
      backgroundColor:
          error ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
      padding: EdgeInsets.all(19.0),
      duration: Duration(milliseconds: 2000),
    ),
  );
}

late SharedPreferences prefs;
bool isDolar = true;
double dolarvalue = 1;
String? imgUser = null;
String? nameUser = null;
bool editando = false;
String currentVersion = "0.0.2";

cargarDolar() async {
  // Obtain shared preferences.
  prefs = await SharedPreferences.getInstance();
  isDolar = await prefs.getBool('dolar') ?? true;
  dolarvalue = await prefs.getDouble('dolarvalue') ?? 1.00;
}

cargarUsuario() async {
  prefs = await SharedPreferences.getInstance();
  imgUser = await prefs.getString('imageBusiness');
  nameUser = await prefs.getString('nameText');
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

//String dropdownValue = listType[0];

int timeToID() {
  //convertir la hora actual a string = 2024-01-03 18:42:42.918227
  var id = DateTime.now().toString();
  DateTime.now().year;
  //reemplazar lo necesario
  id = id.replaceAll('-', '');
  id = id.replaceAll(' ', '');
  id = id.replaceAll(':', '');
  id = id.replaceAll('.', '');
  id = id.substring(2, 15);
  print(id);
  return int.parse(id);
}

/* bool isMobile(context) {
  bool isMobile = prefs.getBool('isfirst') ?? true;
  if (isMobile) {
    return true;
  } else {
    return false;
  }
} */

bool isApp() {
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    return true;
  } else {
    return false;
  }
}

guardarNombreSP(nameText) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('nameText', nameText);
}

guardarDolarSP() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  double dolarCurrentPrice = prefs.getDouble('dolarvalue') ?? 0;
  if (dolarCurrentPrice == 0) {
    Dolar dolarvalue = await firebase().getDolar();
    await prefs.setDouble('dolarvalue', dolarvalue.own!);
  }
}
