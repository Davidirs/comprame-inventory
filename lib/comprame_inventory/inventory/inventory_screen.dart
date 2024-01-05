import 'dart:io';

import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/comprame_inventory/edit_product/edit_product_screen.dart';
import 'package:comprame_inventory/comprame_inventory/models/products.dart';
import 'package:comprame_inventory/comprame_inventory/comprame_inventory_theme.dart';
import 'package:comprame_inventory/comprame_inventory/models/tabIcon_data.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/global.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  int _idproduct = 0;

  bool salirEdit(editando) {
    return false;
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    /*scrollController.addListener(() {
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
      print(sItems);
    });*/
    cargarProductos();
    cargarDolar();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

//creo lista vacia
  List<Product> productList = [];
  //llamo a la base de datos y le paso los valores a la lista
  List<int> sItems = [];
  List<DropdownMenuItem<dynamic>> items = [];
  cargarProductos() async {
    List<Product> auxProduct = await db().getAllProducts();

    productList = auxProduct;

    for (var i = 0; i < productList.length; i++) {
      items.add(DropdownMenuItem(
        child: ListTile(
          leading: Text("#${productList[i].id}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          title: Text("${productList[i].name}"),
          subtitle: Text(
              "${productList[i].buy} \$  /  ${inBs(productList[i].buy!.toDouble())}"),
          isThreeLine: true,
          trailing: Text(
            "${productList[i].units} uds.",
          ),
        ),
        value: productList[i].name,
      ));
    }
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
                idProduct: _idproduct,
                voidCallback: () {
                  printMsg('¡Producto actualizdo satisfactoriamente!', context);
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

  Widget buscador() {
    widget.animationController?.forward();
    print(sItems);

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return SearchChoices.multiple(
      items: items,
      selectedItems: sItems,
      hint: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "Buscar producto",
          style: TextStyle(
            color: isLightMode ? AppTheme.darkText : AppTheme.white,
          ),
        ),
      ),
      searchHint: "Nombre del producto",
      onChanged: (value) {
        setState(() {
          sItems = value;
        });
      },
      displayItem: (item, selected) {
        return (Row(children: [
          selected
              ? Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  color: Colors.grey,
                ),
          SizedBox(width: 7),
          Expanded(
            child: item,
          ),
        ]));
      },
      selectedValueWidgetFn: (item) {
        return Text(
          "#${get(item).id} ${get(item).name} - ${get(item).buy} \$ - ${get(item).units} uds.",
          style: TextStyle(
            color: isLightMode ? AppTheme.darkText : AppTheme.nearlyWhite,
          ),
        );
      },
      doneButton: (selectedItemsDone, doneContext) {
        return (ElevatedButton(
            onPressed: () {
              Navigator.pop(doneContext);
              setState(() {});
            },
            child: Text("Listo")));
      },
      closeButton: null,
      style: TextStyle(fontStyle: FontStyle.italic),
      searchFn: (String keyword, items) {
        List<int> ret = [];
        if (items != null && keyword.isNotEmpty) {
          keyword.split(" ").forEach((k) {
            int i = 0;
            items.forEach((item) {
              if (k.isNotEmpty &&
                  (item.value
                      .toString()
                      .toLowerCase()
                      .contains(k.toLowerCase()))) {
                ret.add(i);
              }
              i++;
            });
          });
        }
        if (keyword.isEmpty) {
          ret = Iterable<int>.generate(items.length).toList();
        }
        return (ret);
      },
      onClear: () {
        limpiarValores();
      },
      clearIcon: Icon(
        Icons.clear_all,
        size: 44,
      ),
      icon: Icon(
        Icons.arrow_drop_down_circle,
        size: 44,
      ),
      /* label: "Carrito de compras",
                underline: Container(
                  height: 1.0,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.teal, width: 3.0))),
                ), */
      iconDisabledColor: Colors.brown,
      iconEnabledColor: Color(0xFFF15C22),
      dropDownDialogPadding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 0,
      ),
      isExpanded: true,
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
            child: productList.length == 0
                ? noProduct()
                : Container(
                    padding: EdgeInsets.only(
                      top: AppBar().preferredSize.height +
                          MediaQuery.of(context).padding.top +
                          24,
                      bottom: 62 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      children: [
                        buscador(),
                        /*
                        Items.length == 0 ? Text("No hay") : Text("Si hay"),
                        SearchChoices.single(
                          items: items,
                          value: sItems,
                          hint: "Select one",
                          searchHint: "Select one",
                          onChanged: (value) {
                            setState(() {
                              sItems = value;
                            });
                          },
                          isExpanded: true,
                        ), 
                        */
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: productList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              widget.animationController?.forward();
                              return dismissibleProduct(index, context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }
      },
    );
  }

  Container dismissibleProduct(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorUnits(productList[index].units),
      ),
      child: Dismissible(
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.edit, color: Colors.white),
              Text(
                "EDITAR",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
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
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.endToStart) {
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
                          print("Eliminar");
                          print(index);
                          db().deleteProduct("${productList[index].id}");
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("ELIMINAR")),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCELAR"),
                    ),
                  ],
                );
              },
            );
          } else {
            print("Editar");
            setState(() {
              _idproduct = productList[index].id!;
              editando = true;
            });

            return false;
          }
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.startToEnd) {
          } else {}
        },
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("#${productList[index].id}"),
              Container(
                  height: 40,
                  width: 40,
                  child: comprobar(File(
                    productList[index].img.toString(),
                  )))
              /* productList[index].img == null ||
                                                  productList[index].img == 'null'
                                              ? Image.asset(
                                                  "assets/img/placeholder.png")
                                              : Image.file(File(productList[index]
                                                  .img
                                                  .toString()))), */
            ],
          ),
          title: Text("${productList[index].name}",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("${dolarBs(productList[index].buy!.toDouble())} - "),
                  Text("${dolarBs(productList[index].sale!.toDouble())}"),
                ],
              ),
              Text(
                "${productList[index].description}",
              ),
            ],
          ),
          isThreeLine: true,
          trailing: Container(
            height: 60,
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${productList[index].units}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                Text("Unidades", style: TextStyle(fontSize: 12.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column noProduct() {
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
                        'Inventario',
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
                    /* 
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: CompraMeInventoryTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: CompraMeInventoryTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '5 Ago',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily:
                                          CompraMeInventoryTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: CompraMeInventoryTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: CompraMeInventoryTheme.grey,
                                  ),
                                ),
                              ),
                            ), */
                    Row(children: [
                      /*IconButton(
                          onPressed: () async {
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
                          )),*/
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
                      IconButton(
                          onPressed: () {
                            // Process data.
                            cargarProductos();
                            setState(() {
                              printMsg("Lista actualizada", context);
                            });
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: HexColor("#ff6600"),
                            size: 30,
                          )),
                    ])
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget comprobar(File imageFile) {
    if (imageFile.existsSync()) {
      // El archivo existe, puedes mostrarlo
      return Image.file(imageFile);
    } else {
      // El archivo no existe, puedes mostrar una imagen de respaldo o un mensaje de error
      return Image.asset("assets/img/placeholder.png");
    }
  }

  Color colorUnits(units) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    if (units < 1) {
      return isLightMode
          ? Colors.red.withOpacity(.3)
          : Colors.red.withOpacity(.8);
    } else if (units < 5) {
      return isLightMode
          ? Colors.yellow.withOpacity(.3)
          : Colors.yellow.withOpacity(.8);
    }

    return isLightMode ? AppTheme.white : AppTheme.white.withOpacity(.8);
  }

  Product get(item) {
    late Product _producto;
    productList.forEach(
      (e) {
        if (e.name == item) {
          _producto = e;
        }
      },
    );

    return _producto;
  }

  void limpiarValores() {
    sItems = [];
    /* subTotales = [];
    total = 0;
    _controllers = []; */
    setState(() {});
  }
}
