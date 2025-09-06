import 'package:flutter/material.dart';

class LayoutTopBottom extends StatelessWidget {
  final Widget widgetTop;
  final Widget widgetBottom;
  final Widget widgetNavigation;
  const LayoutTopBottom({
    super.key,
    required this.widgetTop,
    required this.widgetBottom,
    required this.widgetNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 5, right: 5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;
            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: SizedBox(
                          height: height / 2,
                          width: width,
                          child: widgetTop,
                        ),
                      ),
                      Positioned(
                        top: height / 2,
                        child: SizedBox(
                          height: height / 2,
                          width: width,
                          child: widgetBottom,
                        ),
                      ),
                      widgetNavigation,
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: SizedBox(
                          width: width / 2,
                          height: height,
                          child: widgetTop,
                        ),
                      ),
                      Positioned(
                        left: width / 2,
                        child: SizedBox(
                          width: width / 2,
                          height: height,
                          child: widgetBottom,
                        ),
                      ),
                      widgetNavigation,
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
