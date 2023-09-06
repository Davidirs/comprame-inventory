import 'package:comprame_inventory/comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/comprame_inventory/ui_view/title_view.dart';
import 'package:comprame_inventory/main.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:comprame_inventory/utils.dart';

import '../comprame_inventory_theme.dart';
import '../models/products.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> with TickerProviderStateMixin {
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
    cargarProductos();
    super.initState();
  }

  List<Product> productList = [];

  List<int> sItems = [];
  List lineasProductos = []; //producto,cantidad,subtotal,total

  List<num> subTotales = [];
  List<num> ganancias = [];
  List<TextEditingController> _controllers = [];
  num total = 0;
  num ganancia = 0;
  String detalles = "";
  int method = 0;
  bool isCash = true;
  bool isMovil = false;
  bool isAny = false;
  bool isCard = false;

  List<DropdownMenuItem<dynamic>> items = [];
  cargarProductos() async {
    List<Product> auxProduct = await db().getAllProducts();

    productList = auxProduct;

    for (var i = 0; i < productList.length; i++) {
      items.add(DropdownMenuItem(
        child: ListTile(
          title: Text("${productList[i].name}"),
          subtitle: Text("${productList[i].sale} \$"),
          isThreeLine: true,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("#${productList[i].id}"),
              Text("${productList[i].units} uds."),
            ],
          ),
        ),
        value: productList[i].name,
      ));
    }
    setState(() {});
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
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    widget.animationController?.forward();

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3,
          /* color: Colors.red, */
          padding: EdgeInsets.only(
            top: AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top,
          ),
          child: ListView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              //########################### SELECTOR
              SearchChoices.multiple(
                items: items,
                selectedItems: sItems,
                hint: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Burcar producto"),
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
                    "${get(item).name} - ${get(item).sale} \$ - ${get(item).units} uds.",
                    style: TextStyle(
                      color: CompraMeInventoryTheme.darkText,
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
              ),
            ],
          ),
        ),

        //LISTA DE PRODUCTOS
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Text("Efectivo"),
                    Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/img/cash.png")),
                    Checkbox(
                      checkColor: Colors.white,
                      value: isCash,
                      onChanged: (bool? value) {
                        setState(() {
                          method = 0;
                          CambiarCheckBock();
                        });
                      },
                    ),
                    //Text("Pagomovil"),
                    Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/img/movil.png")),
                    Checkbox(
                      checkColor: Colors.white,
                      value: isMovil,
                      onChanged: (bool? value) {
                        setState(() {
                          method = 1;
                          CambiarCheckBock();
                        });
                      },
                    ),
                    //Text("Biopago"),
                    Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/img/any.png")),
                    Checkbox(
                      checkColor: Colors.white,
                      value: isAny,
                      onChanged: (bool? value) {
                        setState(() {
                          method = 2;

                          CambiarCheckBock();
                        });
                      },
                    ),
                    //Text("Tarjeta"),
                    Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/img/card.png")),
                    Checkbox(
                      checkColor: Colors.white,
                      value: isCard,
                      onChanged: (bool? value) {
                        setState(() {
                          method = 3;

                          CambiarCheckBock();
                        });
                      },
                    ),
                  ],
                ),
              ),
              TitleView(
                titleTxt: 'Lista de productos',
                subTxt: 'Total: ${num.parse(total.toStringAsFixed(2))} \$',
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController!,
                        curve: Interval((1 / 5) * 0, 1.0,
                            curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController!,
              ),
            ],
          ),
        ),
        //#############################   LISTADOS DE PRODUCTOS
        Container(
          padding: EdgeInsets.only(
            bottom: 62 + MediaQuery.of(context).padding.bottom,
          ),
          margin: EdgeInsets.only(
              top: (MediaQuery.of(context).size.height / 3) + 60),
          child: sItems.length == 0
              ? noProduct()
              : ListView.builder(
                  controller: scrollController,
                  itemCount: sItems.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    widget.animationController?.forward();
                    _controllers.add(new TextEditingController());
                    /* subTotales.add(0); */
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                      "assets/img/placeholder.png")),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 140,
                                child: Column(
                                  children: [
                                    Text(
                                      "${productList[sItems[index]].name}",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                        "${productList[sItems[index]].sale} \$"),
                                  ],
                                ),
                              ),
                              Text("X"),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                color: Colors.white,
                                width: 40,
                                child: TextField(
                                  controller: _controllers[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "0",
                                  ),
                                  onChanged: (String) {
                                    calcularTotal();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: 60,
                                  child: Text(
                                    subTotales.isEmpty ||
                                            index > subTotales.length - 1
                                        ? "0.00 \$"
                                        : "${subTotales[index].toStringAsFixed(2)} \$",
                                    //"${subtotal(index)} \$",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  } /* 
                  SizedBox(
                    height: 40,
                  )
                  } */
                  ),
        )
      ],
    );
  }

// header
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
                  children: [
                    /* Container(
                              decoration: BoxDecoration(
                                color: CompraMeInventoryTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: CompraMeInventoryTheme
                                          .nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.arrow_left,
                                  color: HexColor("#ff6600"),
                                  size: 44,
                                ),
                              ),
                            ), */
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Vender',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: CompraMeInventoryTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        letterSpacing: 1.2,
                        color: CompraMeInventoryTheme.darkerText,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          // Process data.
                          var vacios = true;
                          for (var i = 0; i < subTotales.length; i++) {
                            if (subTotales[i] != 0.00) {
                              vacios = false;
                            }
                          }
                          vacios || sItems.length == 0
                              ? printMsg(
                                  "Requiere productos y cantidades", context)
                              : confirmarVenta();
                        },
                        icon: Icon(
                          Icons.done,
                          color: HexColor("#ff6600"),
                          size: 30,
                        )),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
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

/* 
  String subtotal(i) {
    num _subtotal =
        (productList[sItems[i]].sale! * num.parse(_controllers[i].text));
    subTotales.add(_subtotal);
    if (i == sItems.length - 1) {}

    return _subtotal.toStringAsFixed(2);
  }

  calcularTotal() {
    num temp = 0;
    for (var i = 0; i < subTotales.length; i++) {
      temp += subTotales[i];
    }
    total = num.parse(temp.toStringAsFixed(2));
    print("calcularTotal");
    setState(() {});
    //printMensaje(total.toString(), context);
  } */
  calcularTotal() {
    total = 0;
    ganancia = 0;
    lineasProductos = [];
    subTotales = [];
    ganancias = [];

    for (var i = 0; i < sItems.length; i++) {
      try {
        //calcular subtotal
        subTotales.add(
            productList[sItems[i]].sale! * num.parse(_controllers[i].text));
        ganancias.add(
            (productList[sItems[i]].sale! - productList[sItems[i]].buy!) *
                num.parse(_controllers[i].text));
      } catch (e) {
        subTotales.add(0);
        ganancias.add(0);
        print("$e: Cantidad debe ser un número");
      }
      //calcular total
      total += num.parse(subTotales[i].toStringAsFixed(2));
      ganancia += num.parse(ganancias[i].toStringAsFixed(2));
      //llenar lineasProductos

      lineasProductos.add([
        productList[sItems[i]],
        _controllers[i].text,
        subTotales[i].toStringAsFixed(2)
      ]
          /*  "${_controllers[i].text} " + //cantidad,
              "${productList[sItems[i]].name} X " + //producto
              "${productList[sItems[i]].sale} = " + //precio de venta,
              "${subTotales[i].toStringAsFixed(2)} \$ "  */ //subtotal,
          );
    }
    setState(() {});
  }

  noProduct() {
    return Center(
      child: Text("¡No se han seleccionado productos!"),
    );
  }

//creo lista vacia
  List<Venta> ventaList = [];
  //llamo a la base de datos y le paso los valores a la lista
  cargarVentas() async {
    List<Venta> auxVenta = await db().getAllVentas();

    print(auxVenta);
    ventaList = auxVenta;
  }

  confirmarVenta() async {
    cargarVentas();
    detalles = "";
    for (var i = 0; i < lineasProductos.length; i++) {
      detalles += "${lineasProductos[i][1]} " +
          "${lineasProductos[i][0].name} x " +
          "${lineasProductos[i][0].sale} \$ = " +
          "${lineasProductos[i][2]} \$ \n";
    }
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmación"),
          content: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 110,
                  child: ListView(children: [
                    Text(detalles),
                  ] //Text("${lineasProductos[index][0].name}");
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 40, width: 40, child: iconMethod()),
                    Text(
                      "Total: ${num.parse(total.toStringAsFixed(2))} \$",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          //"¿Estás seguro que quieres eliminar?, esta acción no la puedes deshacer."),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  print("${lineasProductos.length} index en lineasProductos");

                  final _venta = Venta(
                    id: ventaList.length == 0 ? 0 : ventaList.last.id! + 1,
                    fecha: DateTime.now().toString(),
                    details: detalles,
                    total: num.parse(total.toStringAsFixed(2)),
                    profit: num.parse(ganancia.toStringAsFixed(2)),
                    method: method
                        .toString(), //0 efectivo, 1 pagomovil,  2 biopago, punto de venta
                  );
                  db().insertVenta(_venta);

                  Navigator.of(context).pop();
                  printMsg('Venta realizada exitosamente!', context);
                  limpiarValores();
                },
                child: const Text("VENDER")),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("CANCELAR"),
            ),
          ],
        );
      },
    );
  }

  void limpiarValores() {
    sItems = [];
    subTotales = [];
    total = 0;
    _controllers = [];
    setState(() {});
  }

  void CambiarCheckBock() {
    isCash = false;
    isMovil = false;
    isAny = false;
    isCard = false;
    switch (method) {
      case 0:
        isCash = true;
        break;
      case 1:
        isMovil = true;
        break;
      case 2:
        isAny = true;
        break;
      default:
        isCard = true;
    }
  }

  Widget iconMethod() {
    var ruta = "assets/img/cash.png";
    switch (method) {
      case 0:
        ruta = "assets/img/cash.png";
        break;
      case 1:
        ruta = "assets/img/movil.png";
        break;
      case 2:
        ruta = "assets/img/any.png";
        break;
      default:
        ruta = "assets/img/card.png";
    }
    return Image.asset(ruta);
  }
}
