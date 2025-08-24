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
    double paddingtStatusBar, paddingBottomMain;
    Orientation rotation = MediaQuery.of(context).orientation;
    if (rotation == Orientation.portrait) {
      paddingtStatusBar = height * 0.04;
      paddingBottomMain = 10;
    } else {
      paddingtStatusBar = height * 0.1;
      paddingBottomMain = 5;
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: paddingtStatusBar,
            left: 10,
            right: 10,
            bottom: paddingBottomMain,
          ),
          decoration: BoxDecoration(color: AppColor.primary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  if (rotation == Orientation.portrait)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: content(),
                    ),
                  if (rotation == Orientation.landscape)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: content(),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  listTileText(
                    () {},
                    Icon(Icons.dashboard_customize_sharp),
                    "Main",
                  ),
                  listTileText(() {}, Icon(Icons.table_chart_rounded), "Data"),
                  listTileText(
                    () {},
                    Icon(Icons.work_history_rounded),
                    "Histori",
                  ),
                  listTileText(
                    () {},
                    Icon(Icons.dashboard_customize_rounded),
                    "Laporan",
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return Column(
                  children: [
                    Flexible(fit: FlexFit.loose, child: widgetTop),
                    const SizedBox(height: 10),
                    Flexible(fit: FlexFit.loose, child: widgetBottom),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(child: widgetTop),
                    const SizedBox(width: 10),
                    Expanded(child: widgetBottom),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  List<Widget> content() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/logo.png", width: 50, height: 50),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pesan Kenyang!", style: labelTextStyle),
              Text(
                "Welcome $namaPerusahaan, jualan lagi kita!",
                style: lv1TextStyle,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  Widget listTileText(VoidCallback onTap, Widget leading, String text) {
    return Flexible(
      fit: FlexFit.loose,
      child: ListTile(
        onTap: onTap,
        title: Column(
          children: [leading, Text(text, style: lv0TextStyle, maxLines: 1)],
        ),
      ),
    );
  }
}
