import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/function/function.dart';
import 'package:flutter_mandiri/model_data/model_cabang.dart';
import 'package:flutter_mandiri/model_data/model_item.dart';
import 'package:flutter_mandiri/model_data/model_kategori.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/style_and_transition/transition_navigator/transition_UpDown.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_standart.dart';
import 'package:flutter_mandiri/widget/widget_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  String? uidUser;
  TextEditingController search = TextEditingController();
  String? selectedfilter;
  String? selectedcabang;
  String? selectedIDcabang;
  String? selectedkategori;
  String? selectedIdkategori;
  String? selectedstatus;
  List<ModelCabang> listCabang = [];
  List<ModelKategori> listKategori = [];
  List<ModelItem> listItem = [];

  int gridviewcount = 0;
  bool isOpen = false;
  bool check = false;
  TextEditingController namaItemController = TextEditingController();
  TextEditingController hargaItemController = TextEditingController();
  TextEditingController kodeBarcodeController = TextEditingController();
  final List<String> status = ["Active", "Deactive"];

  final List<String> filter = [
    "A-Z",
    "Z-A",
    "Terbaru",
    "Terlama",
    "Stock -",
    "Stock +",
  ];

  @override
  void dispose() {
    super.dispose();
    namaItemController.dispose();
    hargaItemController.dispose();
    kodeBarcodeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupData();
    });
  }

  Future<void> setupData() async {
    await _ambilUidUser();
    await _initCabang();
    if (listCabang.isNotEmpty) {
      if (selectedIDcabang != null && uidUser != null) {
        _initKategori();
        _initItem();
      }
    }
  }

  Future<void> _initKategori() async {
    DocumentSnapshot data =
        await FirebaseFirestore.instance
            .collection("items")
            .doc(uidUser!)
            .get();
    if (data.exists && mounted) {
      setState(() {
        listKategori = ModelKategori.getDataListKategori(data);
        selectedIdkategori = listKategori[0].getidKategori;
        selectedkategori = listKategori[0].getnamaKategori;
      });
    }
  }

  Future<void> _initCabang() async {
    DocumentSnapshot data =
        await FirebaseFirestore.instance
            .collection("users")
            .doc("$uidUser")
            .get();
    if (data.exists && mounted) {
      setState(() {
        listCabang = ModelCabang.getDataListCabang(data);
        selectedIDcabang = listCabang[0].getidCabang;
        selectedcabang = listCabang[0].getdaerahCabang;
      });
    }
  }

  Future<void> _initItem() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance
            .collection("items")
            .doc(uidUser!)
            .collection("items")
            .get();
    if (data.size > 0) {
      List<ModelItem> item = ModelItem.getDataListItem(data);
      setState(() {
        listItem = item;
      });
    }
  }

  Future<void> _ambilUidUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uidUser = pref.getString("uid_user");
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    gridviewcount = orientation == Orientation.portrait ? 5 : 4;
    return LayoutTopBottom(
      heightRequested: 1.8,
      widthRequested: 2,
      widgetTop: topLayout(),
      widgetBottom: bottomLayout(),
      widgetNavigation: navigationGesture(),
    );
  }

  Widget topLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 130,
              margin: EdgeInsets.only(top: 5),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isOpen = true;
                  });
                },
                label: Text("Menu", style: lv1TextStyle),
                icon: Icon(Icons.menu),
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: AppColor.primary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text("Inventory", style: titleTextStyle),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: ElevatedButton.icon(
                icon: Icon(Icons.check),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    check ? AppColor.primary : Colors.white,
                  ),
                  elevation: WidgetStateProperty.all(4),
                  padding: WidgetStateProperty.all(EdgeInsets.all(15)),
                ),
                onPressed: () {
                  setState(() {
                    check = !check;
                  });
                },
                label: Text("Condimen", style: labelTextStyle),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<dynamic>(
                  initialValue: selectedfilter,
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
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<ModelCabang>(
                  hint: Text("Cabang", style: lv1TextStyle),
                  items:
                      listCabang
                          .map(
                            (map) => DropdownMenuItem(
                              value: map,
                              child: Text(map.getdaerahCabang),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedcabang = value!.getdaerahCabang;
                      selectedIDcabang = value.getidCabang;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  hint: Text("Status"),
                  items:
                      status
                          .map(
                            (map) =>
                                DropdownMenuItem(value: map, child: Text(map)),
                          )
                          .toList(),
                  onChanged:
                      (value) => (setState(() {
                        selectedstatus = value;
                      })),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          fit: FlexFit.loose,
          child: GridView.builder(
            padding: EdgeInsets.all(5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridviewcount,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: listItem.length,
            itemBuilder: (context, index) {
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Center(child: Image.asset("assets/logo.png")),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(
                            listItem[index].getnamaItem,
                            style: lv0TextStyle,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatUang(listItem[index].gethargaItem),
                          style: lv0TextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Qty", style: lv0TextStyle),
                            Text(
                              listItem[index].getqtyitem,
                              style: lv0TextStyleRED,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget bottomLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Text("Detail", style: titleTextStyle),
        ),
        const SizedBox(height: 30),
        Flexible(
          fit: FlexFit.loose,
          child: customTextField("Nama Item", namaItemController),
        ),
        const SizedBox(height: 10),
        Flexible(
          fit: FlexFit.loose,
          child: customTextField("Kode/Barcode", kodeBarcodeController),
        ),
        const SizedBox(height: 10),
        Flexible(
          fit: FlexFit.loose,
          child: customTextField("Harga", hargaItemController),
        ),
        const SizedBox(height: 10),
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<ModelKategori>(
                  items:
                      listKategori
                          .map(
                            (map) => DropdownMenuItem<ModelKategori>(
                              value: map,
                              child: Text(map.getnamaKategori),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    selectedkategori = value!.getnamaKategori;
                    selectedIdkategori = value.getidKategori;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: selectedcabang),
                  decoration: InputDecoration(
                    enabled: false,
                    labelText: "Cabang",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("Hapus", style: lv1TextStyle),
                  icon: Icon(Icons.delete, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: AppColor.delete,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final item = ModelItem(
                      namaItem: namaItemController.text,
                      idItem: Uuid().v4(),
                      hargaItem: hargaItemController.text,
                      idKategoriItem: "321",
                      statusCondiment: false,
                      urlGambar: "",
                      qtyItem: "0",
                      idCabang: selectedIDcabang!,
                    );
                    item.pushData(uidUser!);
                    setState(() {
                      _initItem();
                    });
                  },
                  label: Text("Simpan", style: lv1TextStyle),
                  icon: Icon(Icons.save, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: AppColor.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget navigationGesture() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: isOpen ? 0 : -290,
      top: 0,
      bottom: 0,
      child: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              // offset: Offset(3, 0),
              blurRadius: 10,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        width: 250,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: ListTile(
                  onTap:
                      () => setState(() {
                        isOpen = false;
                      }),
                  leading: Icon(Icons.keyboard_backspace_rounded),
                  title: Text("Back", style: lv2TextStyle),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Kategori", style: lv2TextStyle),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if (ModalRoute.of(context)!.isCurrent) {
                            customSnackBar(
                              context,
                              "Anda sudah berada diHalaman tersebut",
                            );
                          } else {
                            navUpDownTransition(
                              context,
                              ScreenInventory(),
                              false,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Inventory", style: lv2TextStyle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField(String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 10),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: text,
        labelStyle: lv1TextStyle,
        hintText: "$text ...",
        hintStyle: lv0TextStyle,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
