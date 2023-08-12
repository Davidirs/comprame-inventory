import 'package:best_flutter_ui_templates/db/db.dart';
import 'package:best_flutter_ui_templates/comprame_inventory/ui_view/title_view.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:best_flutter_ui_templates/utils.dart';
import 'package:flutter/material.dart';

import '../comprame_inventory_theme.dart';
import '../models/products.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

final _nameCtrl = TextEditingController();
final _unidCtrl = TextEditingController();
final _buyCtrl = TextEditingController();
final _saleCtrl = TextEditingController();
final _descCtrl = TextEditingController();

class _AddProductScreenState extends State<AddProductScreen>
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
    super.initState();
  }

  List productList = [];
  cargarProductos() async {
    List<Product> auxProduct = await db().getAllProducts();

    productList = auxProduct;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    cargarProductos();
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

  Widget getMainListViewUI() {
    widget.animationController?.forward();
    return Container(
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            TitleView(
              titleTxt: 'Productos',
              subTxt: 'Detalles',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 5) * 0, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: "Nombre",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'No puede estar vacío';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _unidCtrl,
                decoration: InputDecoration(
                  hintText: "Unidades",
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'No puede estar vacío';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TitleView(
              titleTxt: 'Precios',
              subTxt: 'Detalles',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 5) * 0, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _buyCtrl,
                decoration: InputDecoration(
                  hintText: "Compra",
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'No puede estar vacío';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _saleCtrl,
                decoration: InputDecoration(
                  hintText: "Venta",
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'No puede estar vacío';
                  }
                  return null;
                },
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 24, top: 24),
                    height: 100,
                    width: 100,
                    child: Placeholder(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 24 - 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        maxLines: 3,
                        controller: _descCtrl,
                        decoration: InputDecoration(
                          hintText:
                              "Añade una descripción sobre el producto...",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: CompraMeInventoryTheme.background
                        .withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: CompraMeInventoryTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
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
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
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
                                  color: HexColor("#6F56E8"),
                                  size: 44,
                                ),
                              ),
                            ), */
                            SizedBox(
                              width: 40,
                            ),
                            Text(
                              'Agregar',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: CompraMeInventoryTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 22 + 6 - 6 * topBarOpacity,
                                letterSpacing: 1.2,
                                color: CompraMeInventoryTheme.darkerText,
                              ),
                            ),
                            Container(
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
                                      print(productList.length);
                                      if (_formKey.currentState!.validate()) {
                                        final product = Product(
                                          id: productList.length == 0
                                              ? 0
                                              : productList.last.id + 1,
                                          name: _nameCtrl.text,
                                          units: int.parse(_unidCtrl.text),
                                          buy: num.parse(_buyCtrl.text),
                                          sale: num.parse(_saleCtrl.text),
                                        );
                                        db().insertProduct(product);
                                        // Process data.
                                        printMsg(
                                            '¡Producto agregado exitosamente!',
                                            context);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.done,
                                      color: HexColor("#6F56E8"),
                                      size: 30,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

limpiarValores() {
  _nameCtrl.text = "";
  _unidCtrl.text = "0";
  _buyCtrl.text = "0";
  _saleCtrl.text = "0";
  _descCtrl.text = "";
}
