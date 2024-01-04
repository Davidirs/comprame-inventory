import 'package:comprame_inventory/about_screen.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/comprame_inventory/database/database_screen.dart';
import 'package:comprame_inventory/comprame_inventory/login/login_screen.dart';
import 'package:comprame_inventory/custom_drawer/drawer_user_controller.dart';
import 'package:comprame_inventory/custom_drawer/home_drawer.dart';
import 'package:comprame_inventory/feedback_screen.dart';
import 'package:comprame_inventory/help_screen.dart';
import 'package:comprame_inventory/home_screen.dart';
import 'package:comprame_inventory/introduction_animation/introduction_animation_screen.dart';
import 'package:comprame_inventory/invite_friend_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comprame_inventory/dolar_bs_screen.dart';
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

  bool isFirst = false;
  bool isLogin = false;
  isOnce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("valor: ${prefs.getBool('isfirst')}");

    if (prefs.getBool('isfirst') == null) {
      setState(() {
        isFirst = true;
      });
    }
  }

  login() {
    isLogin = !isLogin;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppTheme.white,
        child: SafeArea(
          top: false,
          bottom: false,
          child: isFirst
              ? IntroductionAnimationScreen(
                  isLoginFunction: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isfirst', true);
                    setState(() {
                      isFirst = false;
                    });
                  },
                )
              : StreamBuilder<User?>(
                  stream: _auth.authStateChanges(),
                  builder:
                      (BuildContext context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Muestra un indicador de carga mientras se verifica el estado de autenticación
                    } else {
                      if (snapshot.hasData) {
                        // El usuario está logueado, muestra la pantalla principal
                        return Scaffold(
                          backgroundColor: AppTheme.nearlyWhite,
                          body: DrawerUserController(
                            screenIndex: drawerIndex,
                            drawerWidth:
                                MediaQuery.of(context).size.width * 0.75,
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
                        return LoginPage();
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
