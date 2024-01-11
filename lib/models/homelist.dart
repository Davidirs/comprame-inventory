import 'package:comprame_inventory/pages/comprame_inventory_home_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    /* HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: IntroductionAnimationScreen(),
    ), */
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: CompraMeInventoryHomeScreen(),
    ),
  ];
}
