import 'package:flutter/material.dart';
import 'package:flutter_mandiri/widget_and_style/style/style_font_&_size.dart';

class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  TextEditingController search = TextEditingController();
  String? selectedfilter;
  String? selectedjenis;
  String? selectedstatus;
  TextEditingController namaItemController = TextEditingController();
  final List<String> jenis = ["Makanan", "Minuman"];
  final List<String> status = ["Active", "Deactive"];

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

  final List<String> filter = [
    "A-Z",
    "Z-A",
    "Terbaru",
    "Terlama",
    "Stock -",
    "Stock +",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
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
                            height: height / 1.7,
                            width: width,
                            child: topLayout(),
                          ),
                        ),
                        Positioned(
                          top: height / 1.7,
                          child: SizedBox(
                            height: height / 1.7,
                            width: width,
                            child: bottomLayout(),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: SizedBox(
                            width: width / 1.7,
                            height: height,
                            child: topLayout(),
                          ),
                        ),
                        Positioned(
                          left: width / 1.7,
                          child: SizedBox(
                            width: width / 1.7,
                            height: height,
                            child: bottomLayout(),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget topLayout() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: Text("Menu", style: lv1TextStyle),
                    icon: Icon(Icons.menu),
                    style: ElevatedButton.styleFrom(elevation: 4),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Inventory", style: titleTextStyle),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Search",
                    labelStyle: labelTextStyle,
                    hintText: "Search...",
                    hintStyle: hintTextStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Flexible(
                fit: FlexFit.loose,
                child: DropdownButtonFormField<dynamic>(
                  value: selectedfilter,
                  hint: Text("Filter", style: lv1TextStyle),
                  items:
                      filter
                          .map(
                            (map) =>
                                DropdownMenuItem(value: map, child: Text(map)),
                          )
                          .toList(),

                  onChanged:
                      (value) => (setState(() {
                        selectedfilter = value;
                      })),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedjenis,
                  hint: Text("Jenis", style: lv1TextStyle),
                  items:
                      jenis
                          .map(
                            (map) =>
                                DropdownMenuItem(value: map, child: Text(map)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedjenis = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Flexible(
            fit: FlexFit.loose,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: dummyItems.length,
              itemBuilder: (context, index) {
                return Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Image.asset("assets/logo.png"),
                      ),
                      Text(dummyItems[index], style: lv1TextStyle),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: buttoncustom(() {}, "Condimen", lv1TextStyle)),
                SizedBox(width: 20),
                Expanded(child: buttoncustom(() {}, "A", lv1TextStyle)),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    hint: Text("Status"),
                    items:
                        status
                            .map(
                              (map) => DropdownMenuItem(
                                value: map,
                                child: Text(map),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => (setState(() {
                          selectedstatus = value;
                        })),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomLayout() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: customTextField("Nama Item", namaItemController),
          ),
        ],
      ),
    );
  }

  Widget buttoncustom(VoidCallback onPressed, String text, TextStyle style) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15),
      child: ElevatedButton.icon(
        onPressed: () {},
        label: Text(text, style: style),
      ),
    );
  }

  Widget customTextField(String text, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: lv0TextStyle,
        hintText: text,
        hintStyle: lv0TextStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
