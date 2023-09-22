import 'package:comprame_inventory/comprame_inventory/comprame_inventory_theme.dart';
import 'package:comprame_inventory/comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:flutter/material.dart';

class DateView extends StatefulWidget {
  const DateView({Key? key}) : super(key: key);

  @override
  _DateViewState createState() => _DateViewState();
}

class _DateViewState extends State<DateView> with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    cargarVentas();
    controller.text = today;
    super.initState();
  }

//creo lista vacia
  List<Venta> ventaList = [];
  //llamo a la base de datos y le paso los valores a la lista
  cargarVentas() async {
    List<Venta> auxVenta = await db().getAllVentas();
    ventaList = auxVenta;
    calcToday();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CompraMeInventoryTheme.background,
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
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
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
              child: Text("En desarrollo..."),
            ),
          ),
        ),
        /***************/
      ],
    );
  }

  TextEditingController controller = TextEditingController();
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: CompraMeInventoryTheme.white,
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
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Fecha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: CompraMeInventoryTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          letterSpacing: 1.2,
                          color: CompraMeInventoryTheme.darkerText,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: this.controller,
                        cursorColor: CompraMeInventoryTheme.darkerText,
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:
                                      DateTime(DateTime.now().year - 100),
                                  lastDate: DateTime(DateTime.now().year + 1))
                              .then((value) => controller.text =
                                  '${value!.day.toString()}/${value.month.toString()}/${value.year.toString()}');
                        },
                        style: TextStyle(
                          color: CompraMeInventoryTheme.nearlyDarkBlue,
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: CompraMeInventoryTheme.darkerText),
                          focusColor: CompraMeInventoryTheme.darkerText,
                          filled: false,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: CompraMeInventoryTheme.darkerText),
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today_outlined,
                            size: 24,
                            color: CompraMeInventoryTheme.nearlyDarkBlue,
                          ),
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

  num totalToday = 0;
  num profitToday = 0;
  String today = DateTime.now().toString().substring(0, 10);
  void calcToday() {
    print(today);

    totalToday = 0;
    profitToday = 0;
    for (var i = 0; i < ventaList.length; i++) {
      String fecha = ventaList[i].fecha!.substring(0, 10);
      if (fecha == today) {
        totalToday += num.parse(ventaList[i].total!.toStringAsFixed(2));
        profitToday += num.parse(ventaList[i].profit!.toStringAsFixed(2));
      }
    }
    setState(() {});
  }
}
