//Para imprimir mensaje en el ScackBar
import 'package:flutter/material.dart';

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
