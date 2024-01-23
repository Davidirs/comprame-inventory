import 'package:intl/intl.dart';

//0 efectivo, 1 pagomovil,  2 biopago, punto de venta
List<List> imgMethod = [
  ["Efectivo", "assets/img/cash.png"],
  ["PagoMovil", "assets/img/movil.png"],
  ["BioPago", "assets/img/any.png"],
  ["Tarjeta", "assets/img/card.png"],
];

String date = DateTime.now().toString().substring(0, 10);
String date1 = DateTime.now().toString().substring(0, 10);
bool isInterval = false;

List vendors = [];
List bestvendor = ["Vendedor"];

int numSales = 0;
double totalSales = 0;
double profitSales = 0;

int numEfectivo = 0;
double totalEfectivo = 0;
double gananciaEfectivo = 0;

int numPagoMovil = 0;
double totalPagoMovil = 0;
double gananciaPagoMovil = 0;

int numBioPago = 0;
double totalBioPago = 0;
double gananciaBioPago = 0;

int numTarjeta = 0;
double totalTarjeta = 0;
double gananciaTarjeta = 0;

int bestMethod = 5;
//List vendors = [];

void calcDate(String date, ventaList) {
  resetVariables();
  if (isInterval) {
    DateTime _date = DateTime.parse(date);
    DateTime _date1 = DateTime.parse(date1);
    DateTime tempDay = _date;
    int dia = diferenciaEnDias(_date, _date1);
    print("numeros de dias a calcular ${dia + 1}");

    for (var i = 0; i < dia + 1; i++) {
      String newTempDay = tempDay.toString().substring(0, 10);
      print("Calculando día: " + newTempDay);
      calcDay(newTempDay, ventaList);
      tempDay = sumarDia(tempDay);
    }
  } else {
    calcDay(date, ventaList);
  }
}

DateTime sumarDia(DateTime fecha) {
  return fecha.add(const Duration(days: 1));
}

calcDay(String date, ventaList) {
  for (var i = 0; i < ventaList.length; i++) {
    String fecha = ventaList[i].fecha!.substring(0, 10);
    if (fecha == date) {
      processSale(ventaList[i]);
    }
  }
  to2digit();
  bestMethod = mayor(numEfectivo, numPagoMovil, numBioPago, numTarjeta);
  bestVendor();
}

int diferenciaEnDias(DateTime fecha1, DateTime fecha2) {
  return fecha2.difference(fecha1).inDays;
}
/* void calcDate(String date, ventaList) {
  resetVariables(); // Se agregó una función para reiniciar las variables relevantes.

 // date = desordenarFecha(date);

  for (var i = 0; i < ventaList.length; i++) {
    String fecha = ventaList[i].fecha!.substring(0, 10);
    if (fecha == date) {
      processSale(ventaList[i]);
    }
  }
  to2digit();
  bestMethod = mayor(numEfectivo, numPagoMovil, numBioPago, numTarjeta);
  bestVendor();
  print(bestMethod);
  print(bestvendor);
} */

void resetVariables() {
  vendors = [];
  totalSales = 0;
  profitSales = 0;
  numSales = 0;

  numEfectivo = 0;
  totalEfectivo = 0;
  gananciaEfectivo = 0;

  numPagoMovil = 0;
  totalPagoMovil = 0;
  gananciaPagoMovil = 0;

  numBioPago = 0;
  totalBioPago = 0;
  gananciaBioPago = 0;

  numTarjeta = 0;
  totalTarjeta = 0;
  gananciaTarjeta = 0;
}

void processSale(venta) {
  numSales++;
  totalSales += double.parse(venta.total!.toStringAsFixed(2));
  profitSales += double.parse(venta.profit!.toStringAsFixed(2));

  switch (venta.method!) {
    case "0":
      processEfectivo(venta);
      break;
    case "1":
      processPagoMovil(venta);
      break;
    case "2":
      processBioPago(venta);
      break;
    case "3":
      processTarjeta(venta);
      break;
    default:
  }

  addVendor(venta.vendor);
}

void processEfectivo(venta) {
  numEfectivo++;
  totalEfectivo += double.parse(venta.total!.toStringAsFixed(2));
  gananciaEfectivo += double.parse(venta.profit!.toStringAsFixed(2));
}

void processPagoMovil(venta) {
  numPagoMovil++;
  totalPagoMovil += double.parse(venta.total!.toStringAsFixed(2));
  gananciaPagoMovil += double.parse(venta.profit!.toStringAsFixed(2));
}

void processBioPago(venta) {
  numBioPago++;
  totalBioPago += double.parse(venta.total!.toStringAsFixed(2));
  gananciaBioPago += double.parse(venta.profit!.toStringAsFixed(2));
}

void processTarjeta(venta) {
  numTarjeta++;
  totalTarjeta += double.parse(venta.total!.toStringAsFixed(2));
  gananciaTarjeta += double.parse(venta.profit!.toStringAsFixed(2));
}

void to2digit() {
  numSales = numSales;
  totalSales = double.parse(totalSales.toStringAsFixed(2));
  profitSales = double.parse(profitSales.toStringAsFixed(2));

  numEfectivo = numEfectivo;
  totalEfectivo = double.parse(totalEfectivo.toStringAsFixed(2));
  gananciaEfectivo = double.parse(gananciaEfectivo.toStringAsFixed(2));

  numPagoMovil = numPagoMovil;
  totalPagoMovil = double.parse(totalPagoMovil.toStringAsFixed(2));
  gananciaPagoMovil = double.parse(gananciaPagoMovil.toStringAsFixed(2));

  numBioPago = numBioPago;
  totalBioPago = double.parse(totalBioPago.toStringAsFixed(2));
  gananciaBioPago = double.parse(gananciaBioPago.toStringAsFixed(2));

  numTarjeta = numTarjeta;
  totalTarjeta = double.parse(totalTarjeta.toStringAsFixed(2));
  gananciaTarjeta = double.parse(gananciaTarjeta.toStringAsFixed(2));
}

int mayor(int a, int b, int c, int d) {
  if (a > b && a > c && a > d) {
    return 0;
  } else if (b > a && b > c && b > d) {
    return 1;
  } else if (c > a && c > b && c > d) {
    return 2;
  } else {
    return 3;
  }
}

addVendor(String vendor) {
  bool existe = false;
  int posicion = 0;
  for (var i = 0; i < vendors.length; i++) {
    if (vendors[i].contains(vendor)) {
      existe = true;
      posicion = i;
    }
  }
  if (existe) {
    vendors[posicion][1] = vendors[posicion][1] + 1;
  } else {
    vendors.add([vendor, 1]);
  }
}

void bestVendor() {
  int contador = 0;

  for (var i = 0; i < vendors.length; i++) {
    if (contador < vendors[i][1]) {
      contador = vendors[i][1];
      bestvendor = vendors[i];
    }
  }
}

/* 
void calcDate(date, ventaList) {
  String newDate = desordenarFecha(date);
  print(newDate);
  totalDate = 0;
  profitDate = 0;
  numSales = 0;
  for (var i = 0; i < ventaList.length; i++) {
    String fecha = ventaList[i].fecha!.substring(0, 10);
    if (fecha == date) {
      numSales++;
      totalDate += double.parse(ventaList[i].total!.toStringAsFixed(2));
      profitDate += double.parse(ventaList[i].profit!.toStringAsFixed(2));
      print("Metodo ${ventaList[i].method!}");
      switch (ventaList[i].method!) {
        case "0":
          numEfectivo += 1;
          totalEfectivo += double.parse(ventaList[i].total!.toStringAsFixed(2));
          gananciaEfectivo +=
              double.parse(ventaList[i].profit!.toStringAsFixed(2));
          break;
        case "2":
          numTarjeta = numTarjeta++;
          totalTarjeta += double.parse(ventaList[i].total!.toStringAsFixed(2));
          gananciaTarjeta +=
              double.parse(ventaList[i].profit!.toStringAsFixed(2));

          break;
        default:
      }
    }
  }
  totalDate = double.parse(totalDate.toStringAsFixed(2));
  profitDate = double.parse(profitDate.toStringAsFixed(2));
  print("Suma efectivo ${numEfectivo}");
}  */
/* 
void calcDate(date, ventaList) {
  String newDate = desordenarFecha(date);
  print(newDate);
  totalDate = 0;
  profitDate = 0;
  numSales = 0;
  for (var i = 0; i < ventaList.length; i++) {
    String fecha = ventaList[i].fecha!.substring(0, 10);
    if (fecha == date) {
      numSales++;
      totalDate += num.parse(ventaList[i].total!.toStringAsFixed(2));
      profitDate += num.parse(ventaList[i].profit!.toStringAsFixed(2));
    }
  }
  totalDate = num.parse(totalDate.toStringAsFixed(2));
  profitDate = num.parse(profitDate.toStringAsFixed(2));
  
} */

String ordenarFecha(date) {
  var newDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  return newDate.toString();
}/* 

String desordenarFecha(date) {
  String newDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  return newDate;
}
 */