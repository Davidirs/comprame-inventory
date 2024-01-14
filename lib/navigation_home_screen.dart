import 'package:comprame_inventory/app_theme.dart';
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
    print("ES PRIMERA VEZ: ${prefs.getBool('isfirst')}");
    print("NOMBRE DE USUARIO: ${prefs.getString('nameText')}");
    print("PRECIO DEL DOLAR: ${prefs.getDouble('dolarvalue')}");
    isFirst = prefs.getBool('isfirst') ?? true;
  }

  login() {
    isLogin = !isLogin;
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
}
