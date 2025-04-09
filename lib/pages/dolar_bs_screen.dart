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
  //late final SharedPreferences prefs;
  String? _selectedValue;
  TextEditingController _customController = TextEditingController();
  late SharedPreferences _prefs;
  double? _bcvRate;
  double? _paraleloRate;
  double? _promedioRate;
  //double? _customRate;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () async {
      // Obtain shared preferences.
      prefs = await SharedPreferences.getInstance();
      _controller.text = prefs.getDouble('dolarvalue').toString();
      _loadData();
    });
    super.initState();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _bcvRate = double.tryParse(_prefs.getString('bcv') ?? '');
      _paraleloRate = double.tryParse(_prefs.getString('paralelo') ?? '');
      _promedioRate = double.tryParse(_prefs.getString('promedio') ?? '');
      //_customRate = double.tryParse(_prefs.getString('custom') ?? '');
      // Initialize selected value to a default or previously selected one
      _selectedValue = _prefs.getString('selected_currency_type') ?? 'bcv';
      if (_selectedValue == 'custom') {
       // _customController.text = _prefs.getDouble('custom')?.toString() ?? '';
      }
    });
  }

  Future<void> _saveSelectedValue(String? value) async {
    try {
      if (value != null) {
      
      print(value);
      await _prefs.setString('selected_currency_type', value);
      String precioSelected = _prefs.getString(value) ?? '0';
      print(precioSelected);
      await _prefs.setString('dolarvalue', precioSelected);
      //PENDIENTE AQUI
      await prefs.setDouble('dolarvalue', double.parse(_controller.text));
      printMsg("Precio del dolar actualizado.", context);

      setState(() {
        _selectedValue = value;
      });
    }
    } catch (e) {
      print(e);
    }
    
  }
  

  Future<void> _saveCustomValue(String value) async {
    try {
      //final customValue = double.parse(value);
      await _prefs.setString('custom', value);

      _saveSelectedValue('custom');
      //printMsg("Precio personalizado guardado", context);
      //print("${_prefs.getDouble('custom')}");
    } catch (e) {
      print(e);
      printMsg("Precio Invalido", context, true);
    }
  }

  void printMsg(String msg, BuildContext context, [bool isError = false]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
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
                      color:
                          isLightMode ?  AppTheme.primary : Colors.black,
                      size: 120,
                      shadows: [
                        Shadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(4, 4),
                            blurRadius: 8.0),
                      ],
                    ),
                    // Bcv
                    if (_bcvRate != null)
                      RadioListTile<String>(
                        title: Text('BCV: ${_bcvRate?.toStringAsFixed(2)}'),
                        value: 'bcv',
                        groupValue: _selectedValue,
                        onChanged: (value) => _saveSelectedValue(value),
                      ),
                    // Paralelo
                    if (_paraleloRate != null)
                      RadioListTile<String>(
                        title: Text(
                            'Paralelo: ${_paraleloRate?.toStringAsFixed(2)}'),
                        value: 'paralelo',
                        groupValue: _selectedValue,
                        onChanged: (value) => _saveSelectedValue(value),
                      ),
                    // Promedio
                    if (_promedioRate != null)
                      RadioListTile<String>(
                        title: Text(
                            'Promedio: ${_promedioRate?.toStringAsFixed(2)}'),
                        value: 'promedio',
                        groupValue: _selectedValue,
                        onChanged: (value) => _saveSelectedValue(value),
                      ),
                    // Custom

                    RadioListTile<String>(
                      title: Text('Precio Personalizado:'),
                      value: 'custom',
                      groupValue: _selectedValue,
                      onChanged: (value) =>
                          {_saveCustomValue(_controller.text)},
                    ),
                    /* Container(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '"Precio Personalizado"',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isLightMode ? Colors.black : Colors.white),
          ),
        ), */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily:
                              'AppTheme.fontName', // Replace with your actual font family
                          fontSize: 16,
                          color: isLightMode
                              ? Colors.black
                              : Colors.white, // Adjusted colors
                        ),
                        enabled: _selectedValue == 'custom',
                        cursorColor: AppTheme.primary,
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Ingrese el valor'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedValue == 'custom')
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                isLightMode ? Colors.white : Colors.black,
                            backgroundColor: isLightMode
                                ? AppTheme.primary
                                : Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                            /* shadows: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    offset: const Offset(4, 4),
                    blurRadius: 8.0),
              ], */
                          ),
                          onPressed: () => _saveCustomValue(_controller.text),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'Guardar Precio',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )))));

    /* Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: isLightMode ? AppTheme.primary : Colors.black,
                      size: 120,
                      shadows: [
                        Shadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(4, 4),
                            blurRadius: 8.0),
                      ],
                    ),
                    //bcv
                    //paralelo
                    //Promedio
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '"Precio Personalizado"',
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
                        color: isLightMode
                            ? AppTheme.dark_grey
                            : AppTheme.nearlyWhite,
                      ),
                      cursorColor: AppTheme.primary,
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: '1.00'),
                    ),
                    Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isLightMode ? AppTheme.primary : Colors.white,
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
                              printMsg("Precio Invalido", context, true);
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
            )) 
           );
            
            */
  }
}
