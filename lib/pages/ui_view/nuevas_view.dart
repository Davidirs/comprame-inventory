import 'package:comprame_inventory/app_theme.dart';
import 'package:comprame_inventory/pages/stadistic/date_stadistic_view.dart';
import 'package:comprame_inventory/main.dart';
import 'package:flutter/material.dart';
import '../comprame_inventory_theme.dart';

class NuevasView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const NuevasView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    CompraMeInventoryTheme.nearlyDarkBlue,
                    AppTheme.background,
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: CompraMeInventoryTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nuevas',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: CompraMeInventoryTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: CompraMeInventoryTheme.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: const Text(
                          'Infórmate sobre lo que\nha sucedido hasta ahora',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: CompraMeInventoryTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            color: CompraMeInventoryTheme.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.timer,
                                color: CompraMeInventoryTheme.white,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: const Text(
                                'Linea de tiempo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: CompraMeInventoryTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: CompraMeInventoryTheme.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: CompraMeInventoryTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: CompraMeInventoryTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                  color: AppTheme.primary,
                                  icon: Icon(
                                    Icons.arrow_right,
                                    size: 34,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DateStadisticView(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
