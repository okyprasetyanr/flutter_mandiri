import 'package:flutter/material.dart';
import 'package:flutter_mandiri/widget_and_style/style/style_font_&_size.dart';

class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text("Inventory", style: titleTextStyle)),
        SizedBox(height: 10),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              controller: search,
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: labelTextStyle,
                hintText: "Search...",
                hintStyle: hintTextStyle,
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
