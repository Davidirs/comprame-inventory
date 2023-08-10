  //Para imprimir mensaje en el ScackBar
import 'package:flutter/material.dart';

printMsg(msg, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

