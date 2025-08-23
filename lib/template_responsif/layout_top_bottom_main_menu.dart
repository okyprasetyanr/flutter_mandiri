import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';

class LayoutTopBottomMainMenu extends StatelessWidget {
  final Widget widgetTop;
  final Widget widgetBottom;
  final String namaPerusahaan;
  const LayoutTopBottomMainMenu({
    super.key,
    required this.widgetTop,
    required this.widgetBottom,
    required this.namaPerusahaan,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: height * 0.8,
          child: Container(decoration: BoxDecoration(color: AppColor.primary)),
        ),
        Positioned(
          top: height * (4 / 100),
          left: 10,
          right: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Image.asset(
                      "assets/logo.png",
                      width: 50,
                      height: 50,
                    ),
                  ),

                  SizedBox(width: 10),
                  Text("Pesan Kenyang!", style: labelTextStyle),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome $namaPerusahaan, jualan lagi kita!",
                style: lv1TextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
