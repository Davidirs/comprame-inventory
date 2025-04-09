import 'package:comprame_inventory/Firebase/firestore.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/pages/ui_view/title_view.dart';
import 'package:comprame_inventory/main.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comprame_inventory_theme.dart';
import '../../models/products.dart';

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
    cargarProductos();

    cargarDolar();
    cargarUsuario();

    super.initState();
  }

  List<Product> productList = [];

  List<int> sItems = [];
  List lineasProductos = []; //producto,cantidad,subtotal,total

  List<double> subTotales = [];
  List<double> ganancias = [];
  List<TextEditingController> _controllers = [];
  double total = 0;
  double ganancia = 0;
  String detalles = "";
  int method = 0;
  bool isCash = true;
  bool isMovil = false;
  bool isAny = false;
  bool isCard = false;

  List<DropdownMenuItem<dynamic>> items = [];
  cargarProductos() async {
    if (isApp()) {
      productList = await db().getAllProducts();
    } else {
      productList = await firebase().getAllProducts();
    }

    for (var i = 0; i < productList.length; i++) {
      items.add(DropdownMenuItem(
        child: ListTile(
          title: Text("${productList[i].name}"),
          subtitle: Text(
              "${productList[i].sale} \$  /  ${inBs(productList[i].sale!.toDouble())}"),
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
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.background : AppTheme.nearlyBlack,
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

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return ListView(
      children: [
        //#############################   Buscador
        Buscador(isLightMode),

        isApp()
            ? Container(
                height: 500,
                child: ListView(
                  children: [
                    //#########################    Metodos de pago
                    metodosDePago(isLightMode),
                    listadoDeProductos(isLightMode)
                  ],
                ),
              )
            : Row(
                children: [
                  //#########################    Metodos de pago
                  listadoDeProductos(isLightMode),
                  metodosDePago(isLightMode),
                ],
              )
      ],
    );
  }

  listadoDeProductos(bool isLightMode) {
    return Column(
      children: [
        //#################    tITULO LISTA DE PRODUCTOS
        if (isApp()) Divider(),
        TitleView(
          titleTxt: 'Productos',
          subTxt: 'Total: ${dolarBs(total.toDouble())}',
        ),
        //#############################   LISTADOS DE PRODUCTOS

        Container(
          padding: EdgeInsets.only(
            bottom: 62 + MediaQuery.of(context).padding.bottom,
          ),
          width: isApp()
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          height: 400,
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
                          Container(
                              height: 30,
                              width: 30,
                              child: Image.asset("assets/img/placeholder.png")),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 130,
                            child: Column(
                              children: [
                                Text(
                                  "${productList[sItems[index]].name}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isLightMode
                                        ? AppTheme.darkText
                                        : AppTheme.nearlyWhite,
                                  ),
                                ),
                                Text(
                                  dolarBs(productList[sItems[index]]
                                      .sale!
                                      .toDouble()),
                                  style: TextStyle(
                                    color: isLightMode
                                        ? AppTheme.darkText
                                        : AppTheme.nearlyWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "X",
                            style: TextStyle(
                              color: isLightMode
                                  ? AppTheme.darkText
                                  : AppTheme.nearlyWhite,
                            ),
                          ),
                          SizedBox(
                            width: 5,
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
                            width: 5,
                          ),
                          Container(
                              width: 60,
                              child: Text(
                                subTotales.isEmpty ||
                                        index > subTotales.length - 1
                                    ? "0.00"
                                    : dolarBs(subTotales[index].toDouble()),
                                //"${subtotal(index)} \$",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isLightMode
                                      ? AppTheme.darkText
                                      : AppTheme.nearlyWhite,
                                ),
                              )),
                        ],
                      ),
                    );
                  } /* 
                  SizedBox(
                    height: 40,
                  )
                  } */
                  ),
        ),
      ],
    );
  }

  metodosDePago(bool isLightMode) {
    return Column(
      children: [
        if (isApp()) Divider(),
        TitleView(
          titleTxt: 'Métodos de Pago',
          subTxt: '',
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          width: isApp()
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          height: isApp() ? 75 : 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Text("Efectivo"),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/img/cash.png")),
                      Checkbox(
                        activeColor: AppTheme.primary,
                        fillColor: WidgetStateProperty.all(AppTheme.primary),
                        checkColor: Colors.white,
                        value: isCash,
                        onChanged: (bool? value) {
                          setState(() {
                            method = 0;
                            CambiarCheckBock();
                          });
                        },
                      ),
                    ],
                  ),
                  Text("Efectivo",
                      style: TextStyle(
                        color:
                            isLightMode ? AppTheme.lightText : AppTheme.white,
                      ))
                ],
              ),

              //Text("Pagomovil"),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/img/movil.png")),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: WidgetStateProperty.all(AppTheme.primary),
                        value: isMovil,
                        onChanged: (bool? value) {
                          setState(() {
                            method = 1;
                            CambiarCheckBock();
                          });
                        },
                      ),
                    ],
                  ),
                  Text("PagoMovil",
                      style: TextStyle(
                        color:
                            isLightMode ? AppTheme.lightText : AppTheme.white,
                      ))
                ],
              ),
              //Text("Biopago"),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/img/any.png")),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: WidgetStateProperty.all(AppTheme.primary),
                        value: isAny,
                        onChanged: (bool? value) {
                          setState(() {
                            method = 2;

                            CambiarCheckBock();
                          });
                        },
                      ),
                    ],
                  ),
                  Text("Biopago",
                      style: TextStyle(
                        color:
                            isLightMode ? AppTheme.lightText : AppTheme.white,
                      ))
                ],
              ),
              //Text("Tarjeta"),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/img/card.png")),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: WidgetStateProperty.all(AppTheme.primary),
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
                  Text("Tarjeta",
                      style: TextStyle(
                        color:
                            isLightMode ? AppTheme.lightText : AppTheme.white,
                      ))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Buscador(bool isLightMode) {
    return Container(
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
      ),
      child: SearchChoices.multiple(
        items: items,
        selectedItems: sItems,
        hint: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Buscar producto",
              style: TextStyle(
                color: isLightMode ? AppTheme.darkText : AppTheme.white,
              )),
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
              color: isLightMode ? AppTheme.darkText : AppTheme.nearlyWhite,
            ),
          );
        },
        doneButton: (selectedItemsDone, doneContext) {
          return (ElevatedButton(
              onPressed: () {
                Navigator.pop(doneContext);
                //setState(() {});
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
        iconEnabledColor: AppTheme.primary,
        dropDownDialogPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 0,
        ),
        isExpanded: true,
      ),
    );
  }

// header
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
                        color: isLightMode ? AppTheme.darkText : AppTheme.white,
                      ),
                    ),
                    Row(
                      children: [
                        // cambiar moneda
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
                              color: AppTheme.primary,
                              size: 30,
                            )),
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
                                  ? printMsg("Requiere productos y cantidades",
                                      context, true)
                                  : confirmarVenta();
                            },
                            icon: Icon(
                              Icons.done,
                              color: AppTheme.primary,
                              size: 30,
                            )),
                      ],
                    )
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

  Color getColor(Set<WidgetState> states) {
    return AppTheme.primary;
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
            productList[sItems[i]].sale! * double.parse(_controllers[i].text));
        ganancias.add(
            (productList[sItems[i]].sale! - productList[sItems[i]].buy!) *
                double.parse(_controllers[i].text));
      } catch (e) {
        subTotales.add(0);
        ganancias.add(0);
        print("$e: Cantidad debe ser un número");
      }
      //calcular total
      total += double.parse(subTotales[i].toStringAsFixed(2));
      ganancia += double.parse(ganancias[i].toStringAsFixed(2));
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
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Center(
      child: Text(
        "¡No se han seleccionado productos!",
        style: TextStyle(
          color: isLightMode ? AppTheme.lightText : AppTheme.white,
        ),
      ),
    );
  }

//creo lista vacia
  //List<Venta> ventaList = [];
  //llamo a la base de datos y le paso los valores a la lista
  /* cargarVentas() async {
    List<Venta> auxVenta = await db().getAllVentas();

    ventaList = auxVenta;
  } */

  modificarUnidades() async {
    for (var i = 0; i < lineasProductos.length; i++) {
      if (isApp()) {
        Product product = await db().getProduct(lineasProductos[i][0].id);
        final newProduct = Product(
          id: lineasProductos[i][0].id,
          units: product.units! - int.parse(lineasProductos[i][1]),
        );
        db().decreaseUnitsProduct(newProduct);
      } else {
        Product product =
            await firebase().getProduct(lineasProductos[i][0].id.toString());
        final newProduct = Product(
          id: product.id,
          name: product.name,
          units: product.units! - int.parse(lineasProductos[i][1]),
          type: product.type,
          buy: product.buy,
          sale: product.sale,
          img: product.img,
          description: product.description,
        );
        firebase().addProduct(newProduct);
      }
    }
  }

  confirmarVenta() async {
    //cargarVentas();
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
            width: 150,
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
                  final _venta = Venta(
                    id: timeToID(), //ventaList.length == 0 ? 0 : ventaList.last.id! + 1,
                    fecha: DateTime.now().toString(),
                    details: detalles,
                    total: num.parse(total.toStringAsFixed(2)),
                    profit: num.parse(ganancia.toStringAsFixed(2)),
                    method: method
                        .toString(), //0 efectivo, 1 pagomovil,  2 biopago, punto de venta
                    vendor: nameUser,
                  );
                  if (isApp()) {
                    db().insertVenta(_venta);
                  } else {
                    firebase().addVenta(_venta);
                  }
                  //RESTAR UNIDADES A LOS PRODUCTOS VENDIDOS
                  modificarUnidades();
                  printMsg('Venta realizada exitosamente!', context);
                  Navigator.of(context).pop();
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
