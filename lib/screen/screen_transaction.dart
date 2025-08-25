import 'package:flutter/material.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_standart.dart';

class ScreenTransaction extends StatefulWidget {
  const ScreenTransaction({super.key});

  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction> {
  bool isOpen = false;
  int gridviewcount = 0;
  final List<String> dummyItems = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6",
    "Item 7",
    "Item 8",
    "Item 9",
    "Item 10",
    "Item 11",
    "Item 12",
    "Item 13",
  ];

  @override
  Widget build(BuildContext context) {
    Orientation rotasi = MediaQuery.of(context).orientation;
    gridviewcount = rotasi == Orientation.portrait ? 3 : 4;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 10),
            Flexible(
              fit: FlexFit.loose,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                icon: Icon(Icons.menu),
                label: Text("Menu"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  alignLabelWithHint: false,
                  label: Text("Search", style: lv1TextStyle),
                  hint: Text("Search...", style: lv1TextStyle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(5),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  // aksi di sini
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.qr_code_2_rounded, size: 35),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(5),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.shopping_bag_rounded, size: 35),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 10),
        Flexible(
          fit: FlexFit.loose,
          child: GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: dummyItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridviewcount,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Flexible(child: Image.asset("assets/logo.png")),
                      SizedBox(height: 5),
                      Text(dummyItems[index]),
                    ],
                  ),
                ),
              );
            },
          ),
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
