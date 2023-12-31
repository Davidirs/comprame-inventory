import 'package:comprame_inventory/Firebase/firestore.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:flutter/material.dart';

class DatabasePage extends StatefulWidget {
  @override
  _DatabasePageState createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    return Container(
      color: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
          /* appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back))), */
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 16,
                    right: 16),
                child: Image.asset('assets/images/database.png'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Database',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isLightMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmación"),
                          content: const Text(
                              "¿Estás seguro que quieres subir la base de datos?, esta acción no la puedes deshacer."),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  sendProductsFirebase(context);
                                  sendSalesFirebase(context);
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("SUBIR")),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCELAR"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.cloud_upload),
                  label: Text("Subir Database")),
              SizedBox(
                height: 40,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmación"),
                          content: const Text(
                              "¿Estás seguro que quieres bajar y actualizar la base de datos?, esta acción no la puedes deshacer."),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  readProductFromDb();
                                  readSaleFromDb();
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("DESCARGAR")),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCELAR"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.cloud_download),
                  label: Text("Bajar Database")),
            ],
          ),
        ),
      ),
    );
  }
}
