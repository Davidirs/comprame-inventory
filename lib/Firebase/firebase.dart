// ignore_for_file: invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_core/firebase_core.dart';
import '../models/products.dart';
import '../firebase_options.dart';

firebaseInitializeApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// ... AUTENTICATION

signInWithGoogle(context) async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  AuthCredential credential = await GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  print(userCredential.user?.displayName);
  addUserToDb();
}

/* authStateChanges() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
} */

logOut() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}

User? currentUser() {
  User? user = FirebaseAuth.instance.currentUser;
  return user;
}

//...FIRESTORE

addUserToDb() async {
  final _currentUser = currentUser();

  final db = FirebaseFirestore.instance;
  final user = <String, dynamic>{
    "id": _currentUser!.uid,
    "name": _currentUser.displayName,
    "email": _currentUser.email,
    "phone": _currentUser.phoneNumber,
    "photo": _currentUser.photoURL
  };
  try {
    db.collection("users").doc(_currentUser.email).set(user);
  } catch (e) {
    print(' DocumentSnapshot added with ID: $e');
  }
  /* db.collection("users").add(user).then((DocumentReference doc) =>
      print(' DocumentSnapshot added with ID: ${doc.id}')); */
}

//*********************PENDIENTE*************** */
addSaleToDb(Venta venta) async {
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

updateProduct(data) async {
  final product = dataToProduct(data);
  bool exist = await db().checkIfProductExists(data["id"]);
  try {
    exist ? db().updateProduct(product) : db().insertProduct(product);
  } catch (e) {
    print("Error al actualizar el producto ${data["id"]}: $e");
  }
}

Product dataToProduct(data) {
  final product = Product(
    id: data["id"],
    name: data["name"],
    units: data["units"],
    type: data["type"],
    buy: data["buy"],
    sale: data["sale"],
    img: data["img"],
    description: data["description"],
  );
  return product;
}

updateSale(data) async {
  final venta = dataToSale(data);
  bool exist = await db().checkIfSaleExists(data["id"]);
  try {
    exist ? db().updateVenta(venta) : db().insertVenta(venta);
  } catch (e) {
    print("Error al actualizar el producto ${data["id"]}: $e");
  }
}

Venta dataToSale(data) {
  final venta = Venta(
    id: data["id"],
    fecha: data["fecha"],
    details: data["details"],
    total: data["total"],
    profit: data["profit"],
    method: data["method"],
    vendor: data["vendor"],
  );
  return venta;
}
