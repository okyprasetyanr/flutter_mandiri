import 'package:flutter/material.dart';

class LayoutTopBottomMainMenu extends StatelessWidget {
  final Widget widgetTop;
  final Widget widgetBottom;
  const LayoutTopBottomMainMenu({
    super.key,
    required this.widgetTop,
    required this.widgetBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack());
  }
}
