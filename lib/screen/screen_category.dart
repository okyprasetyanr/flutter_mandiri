import 'package:flutter/material.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_standart.dart';
import 'package:flutter_mandiri/widget/widget_navigation_gesture.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory> {
  bool isOpen = false;
  List<Map<String, dynamic>> contentNavGesture = [];

  @override
  Widget build(BuildContext context) {
    return LayoutTopBottom(
      widgetTop: layoutTop(),
      widgetBottom: layoutBottom(),
      widgetNavigation: navigationGesture(),
    );
  }

  Widget navigationGesture() {
    return NavigationGesture(
      attContent: contentNavGesture,
      isOpen: isOpen,
      close: () {
        setState(() {
          isOpen = false;
        });
      },
    );
  }

  Widget layoutTop() {
    return Text("abcdefghij");
  }

  Widget layoutBottom() {
    return Text("abcdefghij");
  }
}
