import 'dart:io';

import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/comprame_inventory/models/products.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/comprame_inventory/ui_view/title_view.dart';
import 'package:comprame_inventory/main.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../comprame_inventory_theme.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen(
      {Key? key, required this.idProduct, required this.voidCallback})
      : super(key: key);

  final int idProduct;
  final VoidCallback voidCallback;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

AnimationController? animationController;

class _EditProductScreenState extends State<EditProductScreen>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  double topBarOpacity = 0.0;
  @override
  void initState() {
    cargarProductos();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _unidCtrl = TextEditingController();
  final _buyCtrl = TextEditingController();
  final _saleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _dropdownValue = "";
  //String dropdownValue = listType[0];
  late Product product;
  cargarProductos() async {
    Product auxProduct = await db().getProduct(widget.idProduct);

    product = auxProduct;

    _nameCtrl.text = product.name ?? "";
    _unidCtrl.text = "${product.units ?? 0}";
    _dropdownValue = "${product.type}"; //product.type ?? listType.first;
    _buyCtrl.text = "${product.buy ?? 0}";
    _saleCtrl.text = "${product.sale ?? 0}";
    _descCtrl.text = "${product.description ?? 0}";

    print(product.units);
  }

  var imageProductPath = null;
// Método para seleccionar una imagen
  Future selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Aquí puedes manejar la imagen seleccionada
      // En este ejemplo, solo mostraremos la ruta de la imagen
      print(pickedFile.path);
      imageProductPath = pickedFile.path;
    } else {
      imageProductPath = null;
      printMsg("No se seleccionó ninguna imagen.", context, true);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    print("dibujando");
    return Container(
      color: isLightMode ? AppTheme.background : AppTheme.nearlyBlack,
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
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    animationController!.forward();

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
          scrollDirection: Axis.vertical,
          children: <Widget>[
            TitleView(
              titleTxt: 'Productos',
              subTxt: 'Detalles',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: "Nombre",
                  hintStyle: TextStyle(
                    color: isLightMode
                        ? AppTheme.lightText
                        : AppTheme.deactivatedText,
                  ),
                ),
                style: TextStyle(
                  color: isLightMode ? AppTheme.darkText : AppTheme.nearlyWhite,
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
                  hintStyle: TextStyle(
                    color: isLightMode
                        ? AppTheme.lightText
                        : AppTheme.deactivatedText,
                  ),
                ),
                style: TextStyle(
                  color: isLightMode ? AppTheme.darkText : AppTheme.nearlyWhite,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tipo:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: CompraMeInventoryTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: isLightMode ? AppTheme.lightText : AppTheme.white,
                    ),
                  ),
                  DropdownButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: TextStyle(
                      color: isLightMode ? AppTheme.lightText : AppTheme.white,
                    ),
                    underline: Container(
                      height: 2,
                      color: Color(0xfff15c22),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        _dropdownValue = value!;
                        print("Value" + _dropdownValue);
                      });
                    },
                    items:
                        listType.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TitleView(
              titleTxt: 'Precios',
              subTxt: 'Detalles',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _buyCtrl,
                decoration: InputDecoration(
                  hintText: "Compra",
                  hintStyle: TextStyle(
                    color: isLightMode
                        ? AppTheme.lightText
                        : AppTheme.deactivatedText,
                  ),
                ),
                style: TextStyle(
                  color: isLightMode ? AppTheme.darkText : AppTheme.nearlyWhite,
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
                  hintStyle: TextStyle(
                    color: isLightMode
                        ? AppTheme.lightText
                        : AppTheme.deactivatedText,
                  ),
                ),
                style: TextStyle(
                  color: isLightMode ? AppTheme.darkText : AppTheme.nearlyWhite,
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
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(left: 24, top: 24),
                      height: 100,
                      width: 100,
                      child: imageProductPath == null
                          ? Image.asset("assets/img/placeholder.png")
                          : Image.file(File(imageProductPath.toString())),
                    ),
                    onTap: () {
                      selectImage();
                    },
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
                          hintStyle: TextStyle(
                            color: isLightMode
                                ? AppTheme.lightText
                                : AppTheme.deactivatedText,
                          ),
                        ),
                        style: TextStyle(
                          color: isLightMode
                              ? AppTheme.darkText
                              : AppTheme.nearlyWhite,
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
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'EDITAR',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: CompraMeInventoryTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22 + 6 - 6 * topBarOpacity,
                        letterSpacing: 1.2,
                        color: isLightMode ? AppTheme.darkText : AppTheme.white,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final product = Product(
                              id: widget.idProduct,
                              name: _nameCtrl.text,
                              units: int.parse(_unidCtrl.text),
                              type: _dropdownValue,
                              buy: num.parse(_buyCtrl.text),
                              sale: num.parse(_saleCtrl.text),
                              img: imageProductPath,
                              description: _descCtrl.text,
                            );
                            db().updateProduct(product);
                            // Process data.
/* 
                                    Navigator.pop(context); */

                            widget.voidCallback();
                          }
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
        ),
      ],
    );
  }
}
