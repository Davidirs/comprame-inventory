import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/Firebase/firebase.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    firebaseInitializeApp();
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
                child: Image.asset('assets/images/login.jpg'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isLightMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Lo hacemos fácil para ti',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isLightMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      width: 250,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isLightMode ? Colors.black87 : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Material(
                          color: const Color.fromRGBO(0, 0, 0, 0),
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                signInWithGoogle(context);
                              });
                            },
                            icon: Image.asset("assets/images/google.png"
                                /* Icons.info,
                                  color:
                                      isLightMode ? Colors.white : Colors.black,
                                  size: 22, */
                                ),
                            label: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Inicia sesión con Gmail',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isLightMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
              /* Text("Usuario Actual"),
              Text(userCurrent == null
                  ? 'No se ha iniciado sesión'
                  : userCurrent.displayName.toString()), */
            ],
          ),
        ),
      ),
    );
  }
}
