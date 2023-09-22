import 'package:comprame_inventory/comprame_inventory/comprame_inventory_theme.dart';
import 'package:comprame_inventory/comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/comprame_inventory/ui_view/area_list_view.dart';
import 'package:comprame_inventory/comprame_inventory/ui_view/title_view.dart';
import 'package:comprame_inventory/comprame_inventory/ui_view/workout_view.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/main.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StadisticScreen extends StatefulWidget {
  const StadisticScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _StadisticScreenState createState() => _StadisticScreenState();
}

class _StadisticScreenState extends State<StadisticScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    cargarVentas();
    cargarDolar();
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      TitleView(
        titleTxt: 'Tu tienes el control',
        subTxt: 'Detalles',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      WorkoutView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    /* listViews.add(
      Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CompraMeInventoryTheme.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: CompraMeInventoryTheme.grey.withOpacity(0.4),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        /*  ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 74,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: Image.asset("assets/img/back.png"),
                                  ),
                                ),
                              ), */
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 115,
                                    right: 16,
                                    top: 16,
                                  ),
                                  child: Text(
                                    "¡Lo estás haciendo genial!",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily:
                                          CompraMeInventoryTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color:
                                          CompraMeInventoryTheme.nearlyDarkBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 115,
                                bottom: 12,
                                top: 4,
                                right: 16,
                              ),
                              child: Text(
                                "Hoy: $today \nVentas Totales: ${dolarBs(totalToday.toDouble())} \nGanancias Totales: ${dolarBs(profitToday.toDouble())}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: CompraMeInventoryTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  color: CompraMeInventoryTheme.grey
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: calcToday, child: Text("Hola")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -16,
                  left: 0,
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.asset("assets/img/great.png"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ); */

    listViews.add(
      TitleView(
        titleTxt: 'Mejores números',
        subTxt: 'más',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      AreaListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController!,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    return true;
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

  /* Widget getMainListViewUI() {
    return Center(
        child: FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    ));
  } */
  Widget getMainListViewUI() {
    return ListView(
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Tu tienes el control",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: CompraMeInventoryTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: CompraMeInventoryTheme.lightText,
                    ),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Detalles",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: CompraMeInventoryTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: CompraMeInventoryTheme.nearlyDarkBlue,
                          ),
                        ),
                        SizedBox(
                          height: 38,
                          width: 26,
                          child: Icon(
                            Icons.arrow_forward,
                            color: CompraMeInventoryTheme.darkText,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Column(
          children: <Widget>[
            WorkoutView(
              animation: Tween<double>(begin: 1.0, end: 1.0).animate(
                  //animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 5) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController!,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CompraMeInventoryTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color:
                                  CompraMeInventoryTheme.grey.withOpacity(0.4),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: <Widget>[
                          /*  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    child: SizedBox(
                                      height: 74,
                                      child: AspectRatio(
                                        aspectRatio: 1.714,
                                        child: Image.asset("assets/img/back.png"),
                                      ),
                                    ),
                                  ), */
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 115,
                                      right: 16,
                                      top: 16,
                                    ),
                                    child: Text(
                                      "¡Lo estás haciendo genial!",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily:
                                            CompraMeInventoryTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: CompraMeInventoryTheme
                                            .nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 115,
                                  bottom: 12,
                                  top: 4,
                                  right: 16,
                                ),
                                child: Text(
                                  "Hoy: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(today))} \nVentas Totales: ${dolarBs(totalToday.toDouble())} \nGanancias Totales: ${dolarBs(profitToday.toDouble())}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: CompraMeInventoryTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    color: CompraMeInventoryTheme.grey
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -16,
                    left: 0,
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Image.asset("assets/img/great.png"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Estadísticas',
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
