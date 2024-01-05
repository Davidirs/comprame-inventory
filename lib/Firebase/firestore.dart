import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprame_inventory/Firebase/firebase.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/utils.dart';

sendSalesFirebase(context) async {
  List allSales = await db().getAllVentas();
  for (var i = 0; i < allSales.length; i++) {
    addSaleToDb(allSales[i]);
    if (i == allSales.length - 1) {
      printMsg("Ventas subidas exitosamente", context);
    }
  }
  print("SUBIDOS");
}

sendProductsFirebase(context) async {
  List allProducts = await db().getAllProducts();
  for (var i = 0; i < allProducts.length; i++) {
    addProductToDb(allProducts[i]);
    if (i == allProducts.length - 1) {
      printMsg("Productos subidos exitosamente", context);
    }
  }
}

readProductFromDb() {
  final _currentUser = currentUser();
  final db = FirebaseFirestore.instance;
  final docRefProduct =
      db.collection("users").doc(_currentUser!.email).collection("products");
  docRefProduct.get().then((QuerySnapshot<Map<String, dynamic>> snapshot) {
    snapshot.docs.forEach((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      updateProduct(data);
    });

    print("Productos actualizados");
    //printMsg("Productos actualizados", context);
  })
      //.catchError((e) => print("Error al obtener el documento: $e"))
      ;
}

readSaleFromDb() async {
  final _currentUser = currentUser();
  final db = FirebaseFirestore.instance;

  final docRefSale =
      db.collection("users").doc(_currentUser!.email).collection("sales");
  await docRefSale.get().then((QuerySnapshot<Map<String, dynamic>> snapshot) {
    snapshot.docs.forEach((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      updateSale(data);
    });
    //printMsg("Ventas actualizadas", context);
  }) //.catchError((e) => print("Error al obtener el documento: $e"))
      ;
  print("BAJADOS");
}
