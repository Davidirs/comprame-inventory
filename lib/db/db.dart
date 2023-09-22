import 'package:comprame_inventory/comprame_inventory/models/venta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:comprame_inventory/comprame_inventory/models/products.dart';
//import 'products.dart';

class db {
  final String _tableName = "products";

  final String _tableVentas = "sales";

  Future<Database> getDataBase() async {
    return openDatabase(
      join(
          await getDatabasesPath(), "productsDatabase.db"), //primaryDatabase.db
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, name TEXT, units INTEGER, type TEXT, buy REAL, sale REAL, img TEXT, description TEXT)",
        );
        await db.execute(
          "CREATE TABLE $_tableVentas (id INTEGER PRIMARY KEY, fecha TEXT, details TEXT, total REAL, profit REAL, method TEXT)",
        );
      },

      /* onUpgrade: (db, oldVersion, newVersion) async {
        // Aquí puedes agregar las sentencias SQL para actualizar la estructura de la tabla.
        if (oldVersion < 3) {
          await db.execute(
              "ALTER TABLE $_tableName ADD COLUMN type TEXT"); /* 
          await db
              .execute("ALTER TABLE $_tableName ADD COLUMN description TEXT"); */
        }
      }, */
      version: 3, // Incrementa la versión de la base de datos.
    );
  }

  //Insert/Add Method:

  Future<int> insertProduct(Product product) async {
    int productId = 0;
    Database db = await getDataBase();
    await db.insert(_tableName, product.toMap()).then((value) {
      productId = value;
    });
    return productId;
  }

//Get All Method:

  Future<List<Product>> getAllProducts() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> productsMap = await db.query(_tableName);
    return List.generate(productsMap.length, (index) {
      return Product(
        id: productsMap[index]['id'],
        name: productsMap[index]['name'],
        units: productsMap[index]['units'],
        type: productsMap[index]['type'],
        buy: productsMap[index]['buy'],
        sale: productsMap[index]['sale'],
        img: productsMap[index]['img'],
        description: productsMap[index]['description'],
      );
    });
  }

  //get Method
  Future<Product> getProduct(int productId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> product =
        await db.rawQuery("SELECT * FROM $_tableName WHERE id =$productId");
    if (product.length == 1) {
      return Product(
          id: product[0]["id"],
          name: product[0]["name"],
          units: product[0]["units"],
          type: product[0]["type"],
          buy: product[0]["buy"],
          sale: product[0]["sale"],
          img: product[0]["img"],
          description: product[0]["description"]);
    } else {
      return const Product();
    }
  }

  //update method
  Future<void> updateProduct(Product product) async {
    Database db = await getDataBase();
    db.rawUpdate(
        "UPDATE $_tableName SET name ='${product.name}', units ='${product.units}', type ='${product.type}', buy ='${product.buy}',sale ='${product.sale}',img ='${product.img}',description ='${product.description}' WHERE id ='${product.id}'");
  }

  //disminuir cantidad
  Future<void> decreaseUnitsProduct(Product product) async {
    Database db = await getDataBase();
    db.rawUpdate(
        "UPDATE $_tableName SET units ='${product.units}' WHERE id ='${product.id}'");
  }

  //delete method

  Future<void> deleteProduct(String productID) async {
    Database db = await getDataBase();
    db.rawDelete("DELETE FROM $_tableName WHERE id ='$productID'");
  }
//####################################################################
//######################REGISTRO DE VENTAS############################
//####################################################################

  Future<Database> getDBVentas() async {
    return openDatabase(
      join(
          await getDatabasesPath(), "productsDatabase.db"), //primaryDatabase.db
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $_tableVentas (id INTEGER PRIMARY KEY, fecha TEXT, details TEXT, total REAL, profit REAL, method TEXT)", //method INTEGER
        );
      },
      version: 2,
    );
  }
  //Insert/Add Method:

  Future<int> insertVenta(Venta venta) async {
    int ventaId = 0;
    Database db = await getDataBase();
    await db.insert(_tableVentas, venta.toMap()).then((value) {
      ventaId = value;
    });
    return ventaId;
  }

//Get All Method:

  Future<List<Venta>> getAllVentas() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> ventasMap = await db.query(_tableVentas);
    return List.generate(ventasMap.length, (index) {
      return Venta(
        id: ventasMap[index]['id'],
        fecha: ventasMap[index]['fecha'],
        details: ventasMap[index]['details'],
        total: ventasMap[index]['total'],
        profit: ventasMap[index]['profit'],
        method: ventasMap[index]['method'],
      );
    });
  }

  //get Method
  Future<Venta> getVenta(int ventaId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> venta =
        await db.rawQuery("SELECT * FROM $_tableVentas WHERE id =$ventaId");
    if (venta.length == 1) {
      return Venta(
        id: venta[0]["id"],
        fecha: venta[0]["fecha"],
        details: venta[0]["details"],
        total: venta[0]["total"],
        profit: venta[0]["profit"],
        method: venta[0]["method"],
      );
    } else {
      return const Venta();
    }
  }

  //update method
  Future<void> updateVenta(Venta venta) async {
    Database db = await getDataBase();
    db.rawUpdate(
        "UPDATE $_tableVentas SET fecha ='${venta.fecha}', details ='${venta.details}',total ='${venta.total}',profit ='${venta.profit}',method ='${venta.method}' WHERE id ='${venta.id}'");
  }

  //delete method

  Future<void> deleteVenta(String ventaID) async {
    Database db = await getDataBase();
    db.rawDelete("DELETE FROM $_tableVentas WHERE id ='$ventaID'");
  }
}
