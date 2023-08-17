import 'package:comprame_inventory/comprame_inventory/add_product/add_product_screen.dart';
import 'package:comprame_inventory/comprame_inventory/sales/sales_screen.dart';
import 'package:comprame_inventory/comprame_inventory/models/tabIcon_data.dart';
import 'package:comprame_inventory/comprame_inventory/sale/sale.dart';
import 'package:comprame_inventory/comprame_inventory/stadistic/stadistic_screen.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'comprame_inventory_theme.dart';
import 'inventory/inventory_screen.dart';
import 'dart:async';

class CompraMeInventoryHomeScreen extends StatefulWidget {
  @override
  _CompraMeInventoryHomeScreenState createState() =>
      _CompraMeInventoryHomeScreenState();
}

Widget tabBody = Container(
  color: CompraMeInventoryTheme.background,
);

AnimationController? animationController;

class _CompraMeInventoryHomeScreenState
    extends State<CompraMeInventoryHomeScreen> with TickerProviderStateMixin {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = InventoryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CompraMeInventoryTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            //aqui
            /* animationController?.reverse().then<dynamic>((data) {
              if (!mounted) {
                return;
              }
              setState(() {
                tabBody =
                    AddProductScreen(animationController: animationController);
              });
            }); */
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      InventoryScreen(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      SalesScreen(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      StadisticScreen(animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      SaleScreen(animationController: animationController);
                });
              });
            } else if (index == 4) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = AddProductScreen(
                      animationController: animationController);
                });
              });
            } /* else if (index == 5) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = EditProductScreen(
                    animationController: animationController!,
                    idProduct: idproductedit,
                  );
                });
              });
            } */
          },
        ),
      ],
    );
  }
}
