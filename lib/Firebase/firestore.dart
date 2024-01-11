import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprame_inventory/Firebase/firebase.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/models/products.dart';
import 'package:comprame_inventory/models/venta.dart';
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
    firebase().addProduct(allProducts[i]);
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

class firebase {
  Future<List<Product>> getAllProducts() async {
    List<Product> productList = <Product>[];
    final _currentUser = currentUser();
    final db = FirebaseFirestore.instance;
    final docRefProduct =
        db.collection("users").doc(_currentUser!.email).collection("products");
    await docRefProduct
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final product = dataToProduct(data);
        productList.add(product);
      });
      print("Productos actualizados : " + productList.length.toString());
      //printMsg("Productos actualizados", context);
    });
    return productList;
  }

  addProduct(Product producto) async {
    final _currentUser = currentUser();
    final db = FirebaseFirestore.instance;

    db
        .collection("users")
        .doc(_currentUser!.email)
        .collection("products")
        .doc(producto.id.toString())
        .set(producto.toMap())
        .onError((e, _) => print("Error writing document: $e"));
    print("object added");
  }

  getProduct(id) async {
    final _currentUser = currentUser();
    final db = FirebaseFirestore.instance;
    final docRefProduct = db
        .collection("users")
        .doc(_currentUser!.email)
        .collection("products")
        .doc(id);
    Product product = await docRefProduct.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return dataToProduct(data);
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return product;
    //printMsg("Productos actualizados", context);
  }

  deleteProduct(id) {
    final _currentUser = currentUser();
    final db = FirebaseFirestore.instance;
    final docRefProduct = db
        .collection("users")
        .doc(_currentUser!.email)
        .collection("products")
        .doc(id);
    docRefProduct.delete().then(
          (doc) => print("Producto eliminado"),
          onError: (e) => print("Error al eliminar producto"),
        );
  }

  deleteVenta(id) {
    final _currentUser = currentUser();
    final db = FirebaseFirestore.instance;
    final docRefSale = db
        .collection("users")
        .doc(_currentUser!.email)
        .collection("sales")
        .doc(id);
    docRefSale.delete().then(
          (doc) => print("Venta eliminada"),
          onError: (e) => print("Error al eliminar venta"),
        );
  }
  //.catchError((e) => print("Error al obtener el documento: $e"))

  Future<List<Venta>> getAllVentas() async {
    List<Venta> ventaList = <Venta>[];
    final _currentUser = currentUser();
    final db = FirebaseFirestore.instance;
    final docRefVenta =
        db.collection("users").doc(_currentUser!.email).collection("sales");
    await docRefVenta
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final venta = dataToSale(data);
        ventaList.add(venta);
      });
      print("Ventas actualizados : " + ventaList.length.toString());
      //printMsg("Productos actualizados", context);
    });
    return ventaList;
  }

  addVenta(Venta venta) async {
    final _currentUser = currentUser();
    final db = FirebaseFirestore.instance;

    db
        .collection("users")
        .doc(_currentUser!.email)
        .collection("sales")
        .doc(venta.id.toString())
        .set(venta.toMap())
        .onError((e, _) => print("Error writing document: $e"));
    print("object added");
  }
}
