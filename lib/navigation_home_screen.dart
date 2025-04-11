import 'dart:convert';

import 'package:comprame_inventory/Firebase/firestore.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/models/appinfo.dart';
import 'package:comprame_inventory/models/conversion_rate_model.dart';
import 'package:comprame_inventory/pages/about_screen.dart';
import 'package:comprame_inventory/pages/database/database_screen.dart';
import 'package:comprame_inventory/pages/dolar_bs_screen.dart';
import 'package:comprame_inventory/pages/feedback_screen.dart';
import 'package:comprame_inventory/pages/help_screen.dart';
import 'package:comprame_inventory/pages/home_screen.dart';
import 'package:comprame_inventory/pages/invite_friend_screen.dart';
import 'package:comprame_inventory/pages/login/login_screen.dart';
import 'package:comprame_inventory/custom_drawer/drawer_user_controller.dart';
import 'package:comprame_inventory/custom_drawer/home_drawer.dart';
import 'package:comprame_inventory/introduction_animation/introduction_animation_screen.dart';
import 'package:comprame_inventory/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();

    isOnce();

    super.initState();
  }

  bool isFirst = true;
  bool isLogin = false;
  isOnce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    /* double width = MediaQuery.of(context).size.width;
    if (width < 768) {
      prefs.setBool('ismobile', true);
    } else {
      prefs.setBool('ismobile', false);
    }
    print("ES MOBILE : " + isMobile(context).toString()); */
    if (prefs.getBool('isfirst') == null) {
      prefs.setBool('isfirst', true);
    }
    ConversionRateModel? conversionRate = await dataFromAlCambio();

    print("ES conversionRate: ${conversionRate}");
    if (conversionRate != null) {
      prefs.setString('bcv', conversionRate.bcv.toString());
      prefs.setString('paralelo', conversionRate.paralelo.toString());
      prefs.setString('promedio', conversionRate.promedio.toString());
      prefs.setInt('dateParalelo', conversionRate.dateParalelo!);
      prefs.setInt('dateBcvFees', conversionRate.dateBcvFees!);
    }
    print("ES PRIMERA VEZ: ${prefs.getBool('isfirst')}");
    print("NOMBRE DE USUARIO: ${prefs.getString('nameText')}");
    print("PRECIO DEL DOLAR: ${prefs.getDouble('dolarvalue')}");
    isFirst = prefs.getBool('isfirst') ?? true;
    
    getAppVersion();
    firebase().savePriceDolar(conversionRate);
  }

  login() {
    isLogin = !isLogin;
  }

  String lastedVersion = "";
  bool isUpdated = true;
  getAppVersion() async {
    AppInfo appinfo = await firebase().getAppInfo();
    print(appinfo.version);
    lastedVersion = appinfo.version!;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print('version de la app $version');

    switch (version.compareTo(lastedVersion)) {
      case 1:
        isUpdated = true;
      print("Actualizar en firebase");
      updateAppVersion(version);
        break;
      case -1:
      print("Hay una nueva version de la app");
        isUpdated = false;

        break;
      default:
      print("La aplicación está actualizada");
        isUpdated = true;
        break;
    }
    
  }
  updateAppVersion(newVersion) async {
    try {
      await firebase().updateAppVersion(newVersion);
      print("Versión actualizada en Firebase");
    } catch (error) {
      print("Error al actualizar la versión: $error");
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //isOnce();
    return Container(
        color: AppTheme.white,
        child: SafeArea(
          top: false,
          bottom: false,
          child: StreamBuilder<User?>(
            stream: _auth.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Muestra un indicador de carga mientras se verifica el estado de autenticación
              } else {
                if (snapshot.hasData) {
                  // El usuario está logueado, muestra la pantalla principal
                  return Scaffold(
                    backgroundColor: AppTheme.nearlyWhite,
                    body: DrawerUserController(
                      screenIndex: drawerIndex,
                      drawerWidth: isApp()
                          ? MediaQuery.of(context).size.width * 0.75
                          : 300,
                      onDrawerCall: (DrawerIndex drawerIndexdata) {
                        changeIndex(drawerIndexdata);
                        //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
                      },
                      screenView: screenView,
                      //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
                    ),
                  );
                } else {
                  // El usuario no está logueado, muestra la pantalla de login
                  return isFirst && isApp()
                      ? IntroductionAnimationScreen(
                          isLoginFunction: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isfirst', false);
                            setState(() {
                              isFirst = false;
                            });
                          },
                        )
                      : LoginPage();
                }
              }
            }, /* isLogin
                ? Scaffold(
                    backgroundColor: AppTheme.nearlyWhite,
                    body: DrawerUserController(
                      screenIndex: drawerIndex,
                      drawerWidth: MediaQuery.of(context).size.width * 0.75,
                      onDrawerCall: (DrawerIndex drawerIndexdata) {
                        changeIndex(drawerIndexdata);
                        //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
                      },
                      screenView: screenView,
                      //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
                    ),
                  )
                : LoginPage(
                    login: login,
                  ), */
          ),
        ));
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.DolarBS:
          setState(() {
            screenView = DolarBsScreen();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;
        case DrawerIndex.About:
          setState(() {
            screenView = AboutScreen();
          });
          break;
        case DrawerIndex.DB:
          setState(() {
            screenView = DatabasePage();
          });
          break;
        default:
          break;
      }
    }
  }

  Future<ConversionRateModel?> dataFromAlCambio() async {
    final String originalUrl = "https://api.alcambio.app/graphql";

    final Map<String, dynamic> postData = {
      "operationName": "getCountryConversions",
      "query":
          "query getCountryConversions(\$countryCode: String!) { getCountryConversions(payload: {countryCode: \$countryCode}) { _id baseCurrency { code decimalDigits name rounding symbol symbolNative __typename } country { code dial_code flag name __typename } conversionRates { baseValue official principal rateCurrency { code decimalDigits name rounding symbol symbolNative __typename } rateValue type __typename } dateBcvFees dateParalelo dateBcv createdAt __typename } }",
      "variables": {"countryCode": "VE"}
    };

    final Map<String, String> headers = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Apollographql-Client-Name': 'web',
      'Apollographql-Client-Version': '1.0.0',
      // 'Authorization': 'Bearer ' + tuToken, // Si necesitas token
    };

    try {
      final response = await http.post(
        Uri.parse(originalUrl),
        headers: headers,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        ConversionRateModel conversionRate =
            await filtrarDataAlCambio(json['data']['getCountryConversions']);
        return conversionRate;
      } else {
        throw Exception('La solicitud falló con estado ${response.statusCode}');
      }
    } catch (error) {
      return null;
    }
  }

  Future<ConversionRateModel> filtrarDataAlCambio(dynamic data) async {
    double paralelo = data['conversionRates'][0]['baseValue'];
    double bcv = data['conversionRates'][1]['baseValue'];
    double promedio = ((paralelo - bcv) / 2) + bcv;

    ConversionRateModel conversionRate = ConversionRateModel(
      bcv: bcv.toStringAsFixed(2),
      paralelo: paralelo.toStringAsFixed(2),
      promedio: promedio.toStringAsFixed(2),
      dateParalelo: data['dateParalelo'],
      dateBcvFees: data['dateBcvFees'],
    );
    /* 
    String dateParalelo =
        await toLocaleDate(data['dateParalelo']); // Ejemplo: Imprime los datos
    String dateBcvFees =
        await toLocaleDate(data['dateBcvFees']); // Ejemplo: Imprime los datos
    logger.white(conversionRate.toJson()); */
    return conversionRate;
  }
}
