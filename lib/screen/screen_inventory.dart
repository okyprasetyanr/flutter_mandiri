import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/function/function.dart';
import 'package:flutter_mandiri/model_data/model_cabang.dart';
import 'package:flutter_mandiri/model_data/model_item.dart';
import 'package:flutter_mandiri/model_data/model_kategori.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_standart.dart';
import 'package:flutter_mandiri/widget/widget_navigation_gesture.dart';
import 'package:flutter_mandiri/widget/widget_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  final List<Map<String, dynamic>> contentNavGesture = [
    {"toContext": ScreenInventory(), "text_menu": "Inventory", "onTap": () {}},
    {"toContext": ScreenInventory(), "text_menu": "Kategori", "onTap": () {}},
  ];

  String? uidUser;
  TextEditingController search = TextEditingController();
  String? selectedfilter;
  String? selectedcabang;
  String? selectedIDcabang;
  String? selectedkategori;
  String? selectedIdkategori;
  String? selectedstatus;
  bool isOpen = false;
  Map<String, bool> sortir = {'nama_item': true, 'qty_item': true};
  String keySortir = "nama_item";
  List<ModelCabang> listCabang = [];
  List<ModelKategori> listKategori = [];
  List<ModelItem> listItem = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupData();
    });
  }

  int gridviewcount = 0;
  bool checkcondiment = false;
  bool condiment = false;
  TextEditingController namaItemController = TextEditingController();
  TextEditingController get cabangItemController =>
      TextEditingController(text: selectedcabang);
  TextEditingController hargaItemController = TextEditingController();
  TextEditingController kodeBarcodeController = TextEditingController();
  final List<String> status = ["Active", "Deactive"];

  final List<String> filter = ["A-Z", "Z-A", "Stock -", "Stock +"];

  @override
  void dispose() {
    super.dispose();
    namaItemController.dispose();
    hargaItemController.dispose();
    kodeBarcodeController.dispose();
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
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection("kategori").get();
    if (data.size > 0) {
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
            .where('status_condiment', isEqualTo: checkcondiment)
            .where('id_cabang', isEqualTo: selectedIDcabang)
            .where('uid_user', isEqualTo: uidUser)
            .orderBy(keySortir, descending: sortir[keySortir]!)
            .get();
    if (data.size > 0) {
      List<ModelItem> item = ModelItem.getDataListItem(data);
      setState(() {
        listItem = item;
      });
    } else {
      setState(() {
        listItem.clear();
      });
    }
  }

  Future<void> _ambilUidUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uidUser = pref.getString("uid_user");
  }

  @override
  Widget build(BuildContext context) {
    gridviewcount = 4;
    return LayoutTopBottom(
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
            Flexible(
              fit: FlexFit.loose,
              child: ElevatedButton.icon(
                icon: Icon(Icons.check),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    checkcondiment ? AppColor.primary : Colors.white,
                  ),
                  elevation: WidgetStateProperty.all(4),
                  padding: WidgetStateProperty.all(EdgeInsets.all(15)),
                ),
                onPressed: () {
                  setState(() {
                    checkcondiment = !checkcondiment;
                    _initItem();
                  });
                },
                label: Text("Condiment", style: labelTextStyle),
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
                        switch (value) {
                          case "A-Z":
                            keySortir = "nama_item";
                            sortir[keySortir] = false;
                            break;

                          case "Z-A":
                            keySortir = "nama_item";
                            sortir[keySortir] = true;
                            break;

                          case "Stock -":
                            keySortir = "qty_item";
                            sortir[keySortir] = false;
                            break;

                          case "Stock +":
                            keySortir = "qty_item";
                            sortir[keySortir] = true;
                            break;

                          default:
                            keySortir = "nama_item";
                        }

                        _initItem();
                      })),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<ModelCabang>(
                  hint: Text(selectedcabang ?? "Cabang", style: lv1TextStyle),
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
                      _initItem();
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
                  onTap: () {
                    namaItemController.text = listItem[index].getnamaItem;
                    hargaItemController.text = listItem[index].getnamaItem;
                    kodeBarcodeController.text = listItem[index].getBarcode;
                  },
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Qty", style: lv0TextStyle),
                            Text(
                              formatQty(listItem[index].getqtyitem),
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
        Expanded(
          flex: 2,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
            children: [
              customTextField("Nama Item", namaItemController),
              const SizedBox(height: 10),
              customTextField("Kode/Barcode", kodeBarcodeController),
              const SizedBox(height: 10),
              customTextField("Harga", hargaItemController),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<ModelKategori>(
                      hint: Text(
                        selectedkategori ?? "Kategori..",
                        style: hintTextStyle,
                      ),
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: cabangItemController,
                      decoration: const InputDecoration(
                        labelText: "Cabang",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => condiment = !condiment),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 100,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: condiment ? Colors.green : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: (condiment
                                      ? Colors.black
                                      : AppColor.primary)
                                  .withValues(alpha: 0.4),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              curve: Curves.easeInOut,
                              left: condiment ? -50 : 5,
                              duration: Duration(milliseconds: 500),
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                size: 30,
                              ),
                            ),
                            AnimatedPositioned(
                              curve: Curves.easeInOut,
                              left: condiment ? 100 : 150,
                              duration: Duration(milliseconds: 500),
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            AnimatedPositioned(
                              curve: Curves.easeInOut,
                              left: condiment ? -100 : 38,
                              top: 4,
                              duration: Duration(milliseconds: 500),
                              child: Text("Normal", style: lv1TextStyle),
                            ),
                            AnimatedPositioned(
                              curve: Curves.easeInOut,
                              left: condiment ? 10 : 150,
                              top: 4,
                              duration: Duration(milliseconds: 500),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Condiment",
                                  style: lv1TextStyleWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          flex: 1,
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
                    if (namaItemController.text.isEmpty ||
                        hargaItemController.text.isEmpty ||
                        kodeBarcodeController.text.isEmpty ||
                        selectedkategori == null) {
                      // kasih alert/snackbar
                      customSnackBar(context, "Data belum lengkap!");
                    } else {
                      final item = ModelItem(
                        uidUser: uidUser!,
                        namaItem: namaItemController.text,
                        idItem: Uuid().v4(),
                        hargaItem: hargaItemController.text,
                        idKategoriItem: "321",
                        statusCondiment: false,
                        urlGambar: "",
                        qtyItem: 0,
                        idCabang: selectedIDcabang!,
                        barcode: kodeBarcodeController.text,
                      );
                      item.pushData(uidUser!);
                      setState(() {
                        namaItemController.clear();
                        hargaItemController.clear();
                        kodeBarcodeController.clear();
                        _initItem();
                      });
                    }
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
