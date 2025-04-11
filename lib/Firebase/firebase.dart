// ignore_for_file: invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comprame_inventory/models/dolar.dart';
import 'package:comprame_inventory/models/venta.dart';
import 'package:comprame_inventory/db/db.dart';
import 'package:comprame_inventory/utils.dart';
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
/* Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
} */
signInWithGoogle(context) async {
  print('Imprimir un logg');
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  AuthCredential credential = await GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  print('Imprimir un logg');
  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  print('Imprimir un logg');
  print(userCredential.user?.displayName);
  addUserToFirebase();
}

//crear usuario con usuario y contraseña
logInWithUserPass(context,emailAddress,password) async {
try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailAddress,
    password: password
  );

} on FirebaseAuthException catch (e) {
  if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
    printMsg('Correo o contraseña erronea.', context, error:true);
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
  print(e);
  print(e.code);
}
}
//crear usuario con usuario y contraseña
signInWithUserPass(context,emailAddress,password) async {

try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailAddress,
    password: password,
  );

} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    printMsg('Ya existe una cuenta para este correo.', context,error:true);
  }
} catch (e) {
  print(e);
}}

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

addUserToFirebase() async {
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
    guardarNombreSP(_currentUser.displayName);
    guardarDolarSP();
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

Dolar dataToDolar(data) {
  final dolar = Dolar(
    updated: data["updated"],
    bcv: data["bcv"],
    paralelo: data["paralelo"],
    own: data["own"],
  );
  return dolar;
}
