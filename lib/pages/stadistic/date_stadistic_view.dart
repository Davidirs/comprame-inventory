import 'package:comprame_inventory/Firebase/firestore.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/pages/comprame_inventory_theme.dart';
import 'package:comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/pages/stadistic/stadistic_controller.dart';
import 'package:comprame_inventory/pages/ui_view/title_view.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';

class DateStadisticView extends StatefulWidget {
  const DateStadisticView({Key? key}) : super(key: key);

  @override
  _DateStadisticViewState createState() => _DateStadisticViewState();
}

class _DateStadisticViewState extends State<DateStadisticView>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    cargarVentas();
    super.initState();
  }

//creo lista vacia
  List<Venta> ventaList = [];

  //llamo a la base de datos y le paso los valores a la lista
  cargarVentas() async {
    if (isApp()) {
      ventaList = await db().getAllVentas();
    } else {
      ventaList = await firebase().getAllVentas();
    }
    print("formato de date: " + date);
    calcDate(date, ventaList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.background : AppTheme.nearlyBlack,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[getMainListViewUI(), getAppBarUI()],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return ListView(
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24 +
            24,
        //bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      children: [
        Wrap(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(date),
                          firstDate: DateTime(DateTime.now().year - 100),
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value != null) date = value.toString().substring(0, 10);
                    calcDate(date, ventaList);
                    setState(() {});
                  });
                },
                icon: Icon(Icons.calendar_month),
                label: Text(
                  ordenarFecha(date),
                  style: TextStyle(
                    color: CompraMeInventoryTheme.nearlyDarkBlue,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            if (isInterval)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(date1),
                            firstDate: DateTime.parse(date),
                            lastDate: DateTime.now())
                        .then((value) {
                      print("valor:" + value.toString());
                      if (value != null)
                        date1 = value.toString().substring(0, 10);
                      calcDate(date, ventaList);
                      setState(() {});
                    });
                  },
                  icon: Icon(Icons.calendar_month),
                  label: Text(
                    ordenarFecha(date1),
                    style: TextStyle(
                      color: CompraMeInventoryTheme.nearlyDarkBlue,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
        TitleView(
          titleTxt: 'Estadísticas del día',
          subTxt: 'Detales',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CardPadding(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ventas realizadas: ${numSales} ventas"),
                Text("Total en Ventas: ${totalSales}\$"),
                Text("Ganancias obtenidas: ${profitSales}\$"),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              CardPadding(
                Container(
                  width: 130,
                  child: Column(
                    children: [
                      Image.asset("assets/img/cash.png"),
                      Text("Ventas: ${numEfectivo} "),
                      Text("Total: ${totalEfectivo}"),
                      Text("Ganancias: ${gananciaEfectivo}"),
                    ],
                  ),
                ),
              ),
              CardPadding(
                Container(
                  width: 130,
                  child: Column(
                    children: [
                      Image.asset("assets/img/movil.png"),
                      Text("Ventas: ${numPagoMovil} "),
                      Text("Total: ${totalPagoMovil}"),
                      Text("Ganancias: ${gananciaPagoMovil}"),
                    ],
                  ),
                ),
              ),
              CardPadding(
                Container(
                  width: 130,
                  child: Column(
                    children: [
                      Image.asset("assets/img/any.png"),
                      Text("Ventas: ${numBioPago} "),
                      Text("Total: ${totalBioPago}"),
                      Text("Ganancias: ${gananciaBioPago}"),
                    ],
                  ),
                ),
              ),
              CardPadding(
                Container(
                  width: 130,
                  child: Column(
                    children: [
                      Image.asset("assets/img/card.png"),
                      Text("Ventas: ${numTarjeta} "),
                      Text("Total: ${totalTarjeta}"),
                      Text("Ganancias: ${gananciaTarjeta}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /***************/
        ,
        TitleView(
          titleTxt: 'Estadísticas Generales',
          subTxt: 'Detalles',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CardPadding(Column(
            children: [
              Text("Vendedores:"),
              Container(
                height: vendors.length * 60,
                child: ListView.builder(
                    itemCount: vendors.length,
                    itemBuilder: (BuildContext, index) {
                      return ListTile(
                        title: Text(vendors[index][0],
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                        trailing: Container(
                          height: 60,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(vendors[index][1].toString(),
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text("Ventas.", style: TextStyle(fontSize: 12.0)),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              CardPadding(
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 50, //130,
                  child: Column(
                    children: [
                      Text("Método de pago más usado:"),
                      Container(
                          width: 65,
                          child: Image.asset("${imgMethod[bestMethod][1]}")),
                      Text("${imgMethod[bestMethod][0]}"),
                    ],
                  ),
                ),
              ),
              CardPadding(
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 50, //130,
                  child: Column(
                    children: [
                      Text("Vendedor con más ventas:"),
                      Container(
                          width: 65,
                          child: Image.asset('assets/images/userImage.png')),
                      Text(bestvendor[0] ?? "Mejor Vendedor"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        /*  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CompraMeInventoryTheme.nearlyDarkBlue,
                Color.fromARGB(255, 159, 18, 1),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(68.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: CompraMeInventoryTheme.grey.withOpacity(0.6),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text("Método de pago más usado:"),
                ],
              ),
            ),
          ),
        ),
       */
      ],
    );
  }

  String dropdownValue = "Día";
  Widget getAppBarUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
              bottomRight: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: CompraMeInventoryTheme.grey.withOpacity(0.4),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_left,
                          size: 34,
                          color: isLightMode ? AppTheme.grey : AppTheme.white,
                        )),
                    Text(
                      "Ver por ",
                      style: TextStyle(
                        fontFamily: CompraMeInventoryTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        letterSpacing: 1.2,
                        color: isLightMode ? AppTheme.darkText : AppTheme.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppTheme.primary,
                          ),
                          elevation: 16,
                          dropdownColor: isLightMode
                              ? AppTheme.nearlyWhite
                              : AppTheme.nearlyBlack,
                          style: TextStyle(
                            fontFamily: CompraMeInventoryTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            letterSpacing: 1.2,
                            color: isLightMode
                                ? AppTheme.darkText
                                : AppTheme.white,
                          ),
                          underline: Container(
                            height: 2,
                            color: Color(0xfff15c22),
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            if (value == "Día") {
                              isInterval = false;
                            } else {
                              isInterval = true;
                            }
                            calcDate(date, ventaList);
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: listDate
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CardPadding extends StatelessWidget {
  final widget;
  const CardPadding(
    this.widget, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 24),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: CompraMeInventoryTheme.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: CompraMeInventoryTheme.grey.withOpacity(0.4),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: widget,
      ),
    );
  }
}
