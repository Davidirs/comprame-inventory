import 'dart:io';

import 'package:comprame_inventory/Firebase/firestore.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/pages/ui_view/title_view.dart';
import 'package:comprame_inventory/main.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../comprame_inventory_theme.dart';
import '../../models/products.dart';

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
    super.initState();
  }

  List productList = [];
  cargarProductos() async {
    if (isApp()) {
      productList = await db().getAllProducts();
    } else {
      productList = await firebase().getAllProducts();
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    //cargarProductos();
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
      printMsg("No se seleccionó ninguna imagen.", context, error:true);
    }
    setState(() {});
  }

  String dropdownValue = "Uno";
  Widget getMainListViewUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
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
            TitleView(titleTxt: 'Productos', subTxt: 'Detalles'),
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
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    dropdownColor: isLightMode
                        ? AppTheme.nearlyWhite
                        : AppTheme.nearlyBlack,
                    style: TextStyle(
                      color: isLightMode
                          ? AppTheme.lightText
                          : AppTheme.nearlyWhite,
                    ),
                    underline: Container(
                      height: 2,
                      color: AppTheme.primary,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                        print(dropdownValue);
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
                  hintText: "Compra \$",
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
                  hintText: "Venta \$",
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
                      margin: EdgeInsets.only(left: 24, top: 24),
                      height: 100,
                      width: 100,
                      color: CompraMeInventoryTheme.deactivatedText,
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
                                  color: AppTheme.primary,
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
                        color: isLightMode ? AppTheme.darkText : AppTheme.white,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          print("Producto n: ${productList.length}");

                          if (_formKey.currentState!.validate()) {
                            final product = Product(
                              id: timeToID(),
                              name: _nameCtrl.text,
                              units: int.parse(_unidCtrl.text),
                              type: dropdownValue,
                              buy: num.parse(_buyCtrl.text),
                              sale: num.parse(_saleCtrl.text),
                              img: imageProductPath,
                              description: _descCtrl.text,
                            );
                            if (isApp()) {
                              db().insertProduct(product);
                            } else {
                              firebase().addProduct(product);
                            }
                            // Process data.
                            printMsg(
                                '¡Producto agregado exitosamente!', context);
                          }
                        },
                        icon: Icon(
                          Icons.done,
                          color: AppTheme.primary,
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

limpiarValores() {
  _nameCtrl.text = "";
  _unidCtrl.text = "";
  _buyCtrl.text = "";
  _saleCtrl.text = "";
  _descCtrl.text = "";
}
