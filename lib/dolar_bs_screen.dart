import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DolarBsScreen extends StatefulWidget {
  const DolarBsScreen({super.key});

  @override
  State<DolarBsScreen> createState() => _DolarBsScreenState();
}

class _DolarBsScreenState extends State<DolarBsScreen> {
  final _controller = TextEditingController();
  late final SharedPreferences prefs;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // Obtain shared preferences.
      prefs = await SharedPreferences.getInstance();
      _controller.text = prefs.getDouble('dolarvalue').toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
        color: isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
        child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor:
                  isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: isLightMode ? Color(0xfff15c22) : Colors.black,
                      size: 120,
                      shadows: [
                        Shadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(4, 4),
                            blurRadius: 8.0),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '"Precio del dolar"',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isLightMode ? Colors.black : Colors.white),
                      ),
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 16,
                        color: AppTheme.dark_grey,
                      ),
                      cursorColor: Color(0xfff15c22),
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: '1.00'),
                    ),
                    Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isLightMode ? Color(0xfff15c22) : Colors.white,
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
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            try {
                              await prefs.setDouble(
                                  'dolarvalue', double.parse(_controller.text));
                              printMsg("Precio del dolar actualizado", context);
                              print("${prefs.getDouble('dolarvalue')}");
                            } catch (e) {
                              print(e);
                              printMsg("Precio Invalido", context);
                            }
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Guardar cambios',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isLightMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  color:
                                      isLightMode ? Colors.white : Colors.black,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
