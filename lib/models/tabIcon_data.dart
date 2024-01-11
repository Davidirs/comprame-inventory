import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.title = "",
    this.imagePath = '',
    this.index = 4,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String title;
  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      title: 'Inventario',
      imagePath: 'assets/img/tab_1.png',
      selectedImagePath: 'assets/img/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      title: 'Registro',
      imagePath: 'assets/img/tab_2.png',
      selectedImagePath: 'assets/img/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      title: 'Estadísticas',
      imagePath: 'assets/img/tab_3.png',
      selectedImagePath: 'assets/img/tab_3s.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      title: 'Vender',
      imagePath: 'assets/img/tab_4.png',
      selectedImagePath: 'assets/img/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
