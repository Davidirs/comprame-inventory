import 'package:comprame_inventory/comprame_inventory/edit_product/edit_product_screen.dart';
import 'package:comprame_inventory/comprame_inventory/comprame_inventory_theme.dart';
import 'package:comprame_inventory/comprame_inventory/models/tabIcon_data.dart';
import 'package:comprame_inventory/comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/global.dart'; /* 
import 'package:comprame_inventory/utils.dart'; */
import 'package:flutter/material.dart';
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
    List<Venta> auxVenta = await db().getAllVentas();
    ventaList = auxVenta;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CompraMeInventoryTheme.background,
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
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: CompraMeInventoryTheme.background,
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

                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                        color: CompraMeInventoryTheme.white,
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "#${ventaList[ventaList.length - 1 - index].id}"),

                              //Text("${ventaList[ventaList.length-index].method}"),
                            ],
                          ),
                          title: Text(
                              "${ventaList[ventaList.length - 1 - index].fecha!.substring(0, 16)}",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      "Ganancia: ${ventaList[ventaList.length - 1 - index].profit} \$ | ",
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      )),
                                  Text(
                                      "Total: ${num.parse(ventaList[ventaList.length - 1 - index].total!.toStringAsFixed(2))} \$ ",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text(
                                  "${ventaList[ventaList.length - 1 - index].details}",
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
                                ventaList[ventaList.length - 1 - index]
                                    .method!)]),
                          ),
                        ),
                      );
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
                  children: <Widget>[
                    /* 
                            SizedBox(
                              width: 40,
                            ), */
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
                          color: CompraMeInventoryTheme.darkerText,
                        ),
                      ),
                    ),
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
