import 'package:comprame_inventory/about_screen.dart';
import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/custom_drawer/drawer_user_controller.dart';
import 'package:comprame_inventory/custom_drawer/home_drawer.dart';
import 'package:comprame_inventory/feedback_screen.dart';
import 'package:comprame_inventory/help_screen.dart';
import 'package:comprame_inventory/home_screen.dart';
import 'package:comprame_inventory/introduction_animation/introduction_animation_screen.dart';
import 'package:comprame_inventory/invite_friend_screen.dart';
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
  isOnce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("valor: ${prefs.getBool('isfirst')}");

    if (prefs.getBool('isfirst') == null) {
      setState(() {
        isFirst = true;
      });
    }
  }

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
            : Scaffold(
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
              ),
      ),
    );
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
        default:
          break;
      }
    }
  }
}
