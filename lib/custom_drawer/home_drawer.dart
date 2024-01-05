import 'dart:io';

import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/comprame_inventory/comprame_inventory_theme.dart';
import 'package:comprame_inventory/Firebase/firebase.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  @override
  void initState() {
    setDrawerListArray();
    cargarUsuario();
    super.initState();
  }

  //var imageProductPath = null;

  bool isEditing = false;
  //String? name = "";

  /* cargarSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imageProductPath = await prefs.getString('imageBusiness');
    name = await prefs.getString('nameText');
    print("Imagen path: $imageProductPath");
    setState(() {});
  } */

  guardarTexto(String nameText) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nameText', nameText);
  }

// Método para seleccionar una imagen
  Future selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (pickedFile != null) {
      // Aquí puedes manejar la imagen seleccionada
      // En este ejemplo, solo mostraremos la ruta de la imagen
      print(pickedFile.path);
      imgUser = pickedFile.path;
      await prefs.setString('imageBusiness', pickedFile.path);
    } else {
      printMsg("No se seleccionó ninguna imagen.", context, true);
    }
    setState(() {});
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Inicio',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.DolarBS,
        labelName: 'Dolar - Bs',
        icon: Icon(Icons.attach_money),
      ),
      /*  DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Soporte',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'Coméntanos',
        icon: Icon(Icons.help),
      ), */
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'Invita amigos',
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.DB,
        labelName: 'Base de datos',
        icon: Icon(Icons.cloud),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'Acerca de',
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    TextEditingController _controller = TextEditingController();
    final user = currentUser();
    return Scaffold(
      backgroundColor: isLightMode ? AppTheme.background : AppTheme.nearlyBlack,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 -
                            (widget.iconAnimationController!.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 50.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController!,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.white,
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                selectImage();
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                child: imgUser == null
                                    ? Image.asset('assets/images/userImage.png')
                                    : Image.file(File(imgUser.toString())),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 180,
                          child: isEditing
                              ? TextFormField(
                                  controller: _controller,
                                  maxLines: 2,
                                  onChanged: (value) {
                                    nameUser = value;
                                  },
                                )
                              : Text(
                                  nameUser == null
                                      ? 'Usuario o negocio'
                                      : nameUser.toString(),
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isLightMode
                                        ? AppTheme.grey
                                        : AppTheme.white,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.text = nameUser.toString();
                              isEditing = !isEditing;
                              guardarTexto(nameUser.toString());
                            });
                          },
                          icon: Icon(Icons.edit),
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index], isLightMode);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                leading: Image.network(user!.photoURL.toString()),
                title: Text(
                  user.displayName ?? "Anónimos",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isLightMode ? AppTheme.darkText : AppTheme.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  onTapped();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onTapped() {
    //printMsg("Proximamente inicio de sessión.", context);
    // Print to console.
    //signInWithGoogle();
    //authStateChanges();
    /* currentUser();
    print(currentUser()); */
    /* Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage())); */

    confirmarLogOut();
    //logOut();
  }

  confirmarLogOut() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¿Estás seguro que quieres Salir?"),
          /* content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Deberás iniciar sesión con las mismas credenciales para continuar."),
            ],
          ), */
          //"¿Estás seguro que quieres eliminar?, esta acción no la puedes deshacer."),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  logOut();
                },
                child: const Text("CERRAR SESIÓN")),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("CANCELAR"),
            ),
          ],
        );
      },
    );
  }

  Widget inkwell(DrawerList listData, bool isLightMode) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? CompraMeInventoryTheme.nearlyDarkBlue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon?.icon,
                          color: widget.screenIndex == listData.index
                              ? CompraMeInventoryTheme.nearlyDarkBlue
                              : isLightMode
                                  ? AppTheme.nearlyBlack
                                  : AppTheme.nearlyWhite),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? isLightMode
                              ? Colors.black
                              : Colors.white
                          : isLightMode
                              ? AppTheme.nearlyBlack
                              : AppTheme.nearlyWhite,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController!.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 46,
                            decoration: BoxDecoration(
                              color: CompraMeInventoryTheme.nearlyDarkBlue
                                  .withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  DolarBS,
  Help,
  FeedBack,
  DB,
  About,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}
