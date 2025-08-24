import 'package:flutter/material.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_standart.dart';

class ScreenTransaction extends StatefulWidget {
  const ScreenTransaction({super.key});

  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return LayoutTopBottom(
      heightRequested: 2,
      widthRequested: 2,
      widgetTop: layoutTop(),
      widgetBottom: layoutBottom(),
      widgetNavigation: navigationGesture(),
    );
  }

  Widget layoutTop() {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              icon: Icon(Icons.menu),
              label: Text("Menu"),
            ),
            Text(""),
          ],
        ),
      ],
    );
  }

  Widget layoutBottom() {
    return Text("");
  }

  Widget navigationGesture() {
    return AnimatedPositioned(
      left: isOpen ? 0 : -250,
      duration: Duration(milliseconds: 300),
      bottom: 0,
      top: 0,
      child: Container(
        width: 250,
        color: Colors.white,
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              icon: Icon(Icons.arrow_back_rounded),
              label: Text("Tutup"),
            ),
          ],
        ),
      ),
    );
  }
}
