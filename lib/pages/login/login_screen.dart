import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/Firebase/firebase.dart';
import 'package:comprame_inventory/pages/login/register_screen.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          body: SingleChildScrollView(
            child: Column(
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
                    'Iniciar sesión',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Campo de correo electrónico
                        Container(
                          height: 70,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: 'Correo electrónico'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingresa tu correo electrónico';
                              }
                              // Puedes agregar más validaciones aquí, como verificar el formato del correo
                              return null;
                            },
                          ),
                        ),

                        // Campo de contraseña
                        Container(
                          height: 70,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration:
                                InputDecoration(labelText: 'Contraseña'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingresa tu contraseña';
                              }
                              if (value!.length < 6) {
                                return 'La contraseña debe tener almenos 6 dígitos';
                              }
                              // Puedes agregar más validaciones aquí, como requerir una contraseña fuerte
                              return null;
                            },
                          ),
                        ),


                        
                        SizedBox(
                          height: 24,
                        ),
                        
                        InkWell(
                onTap: () {
                   print(_emailController.text);
                            if (_formKey.currentState!.validate()) {
                              logInWithUserPass(context, _emailController.text,
                                  _passwordController.text);
                              // Aquí realizarás la lógica para enviar los datos al servidor
                              // y manejar la autenticación
                            }

                },
                child: Container(
                  height: 58,
                  padding: EdgeInsets.only(
                    left: 56.0,
                    right: 56.0,
                    top: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.0),
                    color: Color(0xfff15c22),
                  ),
                  child: Text(
                    "Iniciar sesión",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextButton(onPressed: (){
                Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
              }, child: Text('¿Aún no tienes cuenta?, Regístrate.'))
                        /* Container(
                          margin: EdgeInsets.only(top: 8),
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
                                      color: isLightMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              )),
                        ), */
                      ],
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
      ),
    );
  }
}
