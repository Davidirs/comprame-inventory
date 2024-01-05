import 'package:comprame_inventory/Firebase/firestore.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/comprame_inventory/edit_product/edit_product_screen.dart';
import 'package:comprame_inventory/comprame_inventory/comprame_inventory_theme.dart';
import 'package:comprame_inventory/comprame_inventory/models/tabIcon_data.dart';
import 'package:comprame_inventory/comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/global.dart'; /* 
import 'package:comprame_inventory/utils.dart'; */
import 'package:comprame_inventory/main.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
/* 
import '../../main.dart'; */

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 1.0;
  int _idventa = 0;

  bool salirEdit(editando) {
    return false;
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    /* scrollController.addListener(() {
      print(24 - scrollController.offset);
      if (24 - scrollController.offset >= -24) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= -24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      }
    }); */
    cargarVentas();
    cargarDolar();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  //0 efectivo, 1 pagomovil,  2 biopago, punto de venta
  List<String> imgMethod = [
    "assets/img/cash.png",
    "assets/img/movil.png",
    "assets/img/any.png",
    "assets/img/card.png",
  ];

//creo lista vacia
  List<Venta> ventaList = [];
  //llamo a la base de datos y le paso los valores a la lista
  cargarVentas() async {
    ventaList = await db().getAllVentas();
    Future.delayed(
        Duration(seconds: 1),
        () => {
              setState(() {}),
            });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.background : AppTheme.nearlyBlack,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: editando
            ? EditProductScreen(
                idProduct: _idventa,
                voidCallback: () {
                  setState(() {
                    editando = false;
                  });
                })
            : Stack(
                children: <Widget>[
                  getMainListViewUI(),
                  getAppBarUI(),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              ),
      ),
    );
  }

  Widget getMainListViewUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: isLightMode ? AppTheme.background : AppTheme.nearlyBlack,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: ventaList.length == 0
                ? noVenta()
                : ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      top: AppBar().preferredSize.height +
                          MediaQuery.of(context).padding.top +
                          24,
                      bottom: 62 + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: ventaList.length,
                    scrollDirection: Axis.vertical,
                    //reverse: true, //posible solucion
                    itemBuilder: (BuildContext context, int index) {
                      widget.animationController?.forward();
                      int indexInverso = ventaList.length - 1 - index;

                      String formattedDate = DateFormat('dd-MM-yyyy – kk:mm')
                          .format(
                              DateTime.parse(ventaList[indexInverso].fecha!));
                      return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isLightMode
                                ? AppTheme.white
                                : AppTheme.white.withOpacity(.8),
                          ),
                          child: Dismissible(
                            background: Container(
                                /* decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.edit, color: Colors.white),
                                  Text(
                                    "EDITAR",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                                ],
                              ), */
                                ),
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                                  Text(
                                    "ELIMINAR",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(Icons.delete, color: Colors.white),
                                ],
                              ),
                            ),
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (DismissDirection direction) async {
                              //if (direction == DismissDirection.endToStart) {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmación"),
                                    content: const Text(
                                        "¿Estás seguro que quieres eliminar?, esta acción no la puedes deshacer."),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () {
                                            try {
                                              print(indexInverso);
                                              print(ventaList[indexInverso].id);
                                              db().deleteVenta(
                                                  ventaList[indexInverso].id!);

                                              cargarVentas();

                                              printMsg(
                                                  "Venta eliminada exitosamente",
                                                  context);
                                              Navigator.of(context).pop(true);
                                            } catch (e) {
                                              printMsg(
                                                  "Error al eliminar venta",
                                                  context,
                                                  true);
                                              Navigator.of(context).pop(false);
                                            }
                                          },
                                          child: const Text("ELIMINAR")),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("CANCELAR"),
                                      ),
                                    ],
                                  );
                                },
                              );
                              /* } else {
                                print("No hace nada");
                                /* setState(() {
                                  _idventa = ventaList[index].id!;
                                  editando = true;
                                }); */

                                return false;
                              } */
                            },
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                //ventaList.removeAt(indexInverso);
                              } else {}
                            },
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("#${ventaList.length - index}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text("${ventaList[indexInverso].vendor}"),
                                ],
                              ),
                              title: Text(formattedDate,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Total: ${dolarBs(ventaList[indexInverso].total!.toDouble())}",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "Ganancia: ${dolarBs(ventaList[indexInverso].profit!.toDouble())} | ",
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      )),
                                  Text("${ventaList[indexInverso].details}",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: Container(
                                width: 40,
                                height: 40,
                                child: Image.asset(imgMethod[int.parse(
                                    ventaList[indexInverso].method!)]),
                              ),
                            ),
                          ));
                    },
                  ),
          );
        }
      },
    );
  }

  Column noVenta() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("¡No hay productos registrados!"),
      ],
    );
  }

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ventas',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: CompraMeInventoryTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          //Cambié de 22 a 20
                          letterSpacing: 1.2,
                          color:
                              isLightMode ? AppTheme.darkText : AppTheme.white,
                        ),
                      ),
                    ),
                    Row(children: [
                      IconButton(
                          onPressed: () async {
                            //db().deleteVenta(ventaList[ventaList.length - 1].id!);
                            await sendSalesFirebase(context);
                            await readSaleFromDb();
/*  */
                            Future.delayed(
                                Duration(seconds: 2),
                                () => {
                                      cargarVentas(),
                                      printMsg("Lista de ventas sincronizada",
                                          context),
                                      print("TABLA ACTUALIZADA"),
                                    });
                          },
                          icon: Icon(
                            Icons.cloud_sync,
                            color: HexColor("#ff6600"),
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () async {
                            //cambiar moneda
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (await prefs.getBool('dolar') == null) {
                              await prefs.setBool('dolar', true);
                            } else {
                              await prefs.setBool(
                                  'dolar', !prefs.getBool('dolar')!);
                            }
                            isDolar = prefs.getBool('dolar')!;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.price_change_outlined,
                            color: HexColor("#ff6600"),
                            size: 30,
                          )),
                    ]),
                    /*  Container(
                              decoration: BoxDecoration(
                                color: CompraMeInventoryTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: CompraMeInventoryTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                    onPressed: () {
                                      // Process data.

                                      cargarVentas();
                                      setState(() {
                                        printMsg("Tabla actualizada", context);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: HexColor("#ff6600"),
                                      size: 30,
                                    )),
                              ),
                            ), */
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
