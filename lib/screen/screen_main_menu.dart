import 'package:flutter/widgets.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_main_menu.dart';

class ScreenMainMenu extends StatefulWidget {
  const ScreenMainMenu({super.key});

  @override
  State<ScreenMainMenu> createState() => _ScreenMainMenuState();
}

class _ScreenMainMenuState extends State<ScreenMainMenu> {
  @override
  Widget build(BuildContext context) {
    return LayoutTopBottomMainMenu(
      widgetTop: LayoutTop(),
      widgetBottom: LayoutBottom(),
    );
  }
}

Widget LayoutBottom() {
  return Text("");
}

Widget LayoutTop() {
  return Text("");
}
