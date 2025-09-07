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
  String? uidUser;
  TextEditingController search = TextEditingController();
  String? selectedfilter;
  String? selectedcabang;
  String? selectedIDcabang;
  String? selectedkategori;
  String? selectedIdkategori;
  String? selectedstatus;
  String? iditemUpdate;
  String? idkategoriUpdate;
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
    _gotoPage(currentPage);
  }

  final List<Map<String, dynamic>> contentNavGesture = [
    {"toContext": ScreenInventory(), "text_menu": "Inventory", "onTap": () {}},
  ];
  int gridviewcount = 0;
  bool checkcondiment = false;
  bool condiment = false;
  TextEditingController namaItemController = TextEditingController();
  TextEditingController get cabangItemController =>
      TextEditingController(text: selectedcabang);
  TextEditingController hargaItemController = TextEditingController();
  TextEditingController kodeBarcodeController = TextEditingController();
  TextEditingController namaKategoriController = TextEditingController();
  PageController pageControllerTop = PageController();
  PageController pageControllerBottom = PageController();
  bool currentPage = true;
  final List<String> status = ["Active", "Deactive"];

  final List<String> filter = ["A-Z", "Z-A", "Stock -", "Stock +"];

  @override
  void dispose() {
    super.dispose();
    namaItemController.dispose();
    hargaItemController.dispose();
    kodeBarcodeController.dispose();
  }

  void _gotoPage(bool page) {
    int goto = page ? 0 : 1;
    setState(() {
      currentPage = page;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageControllerTop.hasClients && pageControllerBottom.hasClients) {
        pageControllerTop.animateToPage(
          goto,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        pageControllerBottom.animateToPage(
          goto,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
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
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance
            .collection("kategori")
            .where("uid_user", isEqualTo: uidUser)
            .where("id_cabang", isEqualTo: selectedIDcabang)
            .orderBy("nama_kategori", descending: false)
            .get();

    setState(() {
      if (data.size > 0) {
        listKategori = ModelKategori.getDataListKategori(data);
        selectedIdkategori = listKategori[0].getidKategori;
        selectedkategori = listKategori[0].getnamaKategori;
      } else {
        listKategori.clear();
      }
    });
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

    setState(() {
      if (data.size > 0) {
        List<ModelItem> item = ModelItem.getDataListItem(data);
        listItem = item;
      } else {
        listItem.clear();
      }
    });
  }

  Future<void> _ambilUidUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uidUser = pref.getString("uid_user");
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
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
                label: Text("Menu", style: lv1TextStyleWhite),
                icon: Icon(Icons.menu),
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.white,
                  elevation: 4,
                  backgroundColor: AppColor.primary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _gotoPage(!currentPage);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 150,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                height: 55,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      curve: Curves.easeInOut,
                      left: currentPage ? -200 : 18,
                      top: 4,
                      duration: Duration(milliseconds: 500),
                      child: rowContentAnim(
                        Icon(Icons.swap_horiz_rounded, size: 35),
                        Text("Kategori", style: titleTextStyle),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeInOut,
                      left: currentPage ? 0 : 300,
                      top: 4,
                      duration: Duration(milliseconds: 500),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: rowContentAnim(
                          Icon(Icons.swap_horiz_rounded, size: 35),
                          Text("Inventory", style: titleTextStyle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: PageView(
            controller: pageControllerTop,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          style: lv1TextStyle,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            labelText: "Search",
                            labelStyle: labelTextStyle,
                            hint: Text("Search...", style: lv1TextStyle),
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
                            padding: WidgetStateProperty.all(
                              EdgeInsets.all(15),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              checkcondiment = !checkcondiment;
                              _initItem();
                            });
                          },
                          label: Text("Condiment", style: lv05TextStyle),
                        ),
                      ),
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
                            style: lv05TextStyle,
                            hint: Text("Filter", style: lv1TextStyle),
                            items:
                                filter
                                    .map(
                                      (map) => DropdownMenuItem(
                                        value: map,
                                        child: Text(map),
                                      ),
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
                          flex: 2,
                          child: DropdownButtonFormField<ModelCabang>(
                            style: lv05TextStyle,
                            hint: Text(
                              selectedcabang ?? "Cabang",
                              style: lv1TextStyle,
                            ),
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
                                _initKategori();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            style: lv05TextStyle,
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
                        childAspectRatio: 2 / 3,
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
                              namaItemController.text =
                                  listItem[index].getnamaItem;
                              hargaItemController.text =
                                  listItem[index].gethargaItem;
                              kodeBarcodeController.text =
                                  listItem[index].getBarcode;
                              iditemUpdate = listItem[index].getidItem;
                              setState(() {
                                iditemUpdate = listItem[index].getidItem;
                                selectedkategori =
                                    listKategori
                                        .firstWhere(
                                          (kategori) =>
                                              kategori.getidKategori ==
                                              listItem[index].getidKategoriItem,
                                          orElse:
                                              () => ModelKategori(
                                                namaKategori: "Kategori...",
                                                idkategori: "1",
                                              ),
                                        )
                                        .getnamaKategori;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Center(
                                      child: Image.asset("assets/logo.png"),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      listItem[index].getnamaItem,
                                      style: lv05TextStyle,
                                    ),
                                  ),
                                  Text(
                                    formatUang(listItem[index].gethargaItem),
                                    style: lv05TextStyle,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Qty", style: lv05TextStyle),
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
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    width: 150,
                    child: DropdownButtonFormField<ModelCabang>(
                      style: lv05TextStyle,
                      hint: Text(
                        selectedcabang ?? "Cabang",
                        style: lv05TextStyle,
                      ),
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
                          _initKategori();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listKategori.length,
                      itemBuilder: (context, index) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                                Colors.black,
                                Colors.transparent,
                              ],
                              stops: [0, 0.02, 0.98, 1],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Material(
                            color:
                                index % 2 == 0
                                    ? const Color.fromARGB(255, 235, 235, 235)
                                    : const Color.fromARGB(255, 221, 221, 221),
                            child: InkWell(
                              onTap: () {
                                namaKategoriController.text =
                                    listKategori[index].getnamaKategori;
                                idkategoriUpdate =
                                    listKategori[index].getidKategori;
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                  top: 10,
                                  bottom: 10,
                                ),

                                child: Text(
                                  listKategori[index].getnamaKategori,
                                  style: lv1TextStyle,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
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
          child: GestureDetector(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 250,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              height: 60,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    curve: Curves.easeInOut,
                    right: currentPage ? -250 : 0,
                    top: 4,
                    duration: Duration(milliseconds: 500),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        namaKategoriController.clear();
                        idkategoriUpdate = null;
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      icon: Icon(Icons.restart_alt_rounded, size: 25),
                      label: Text("Detail Kategori", style: titleTextStyle),
                    ),
                  ),
                  AnimatedPositioned(
                    curve: Curves.easeInOut,
                    right: currentPage ? 0 : 350,
                    top: 4,
                    duration: Duration(milliseconds: 500),
                    child: ElevatedButton.icon(
                      onPressed: _reset,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      icon: Icon(Icons.restart_alt_rounded, size: 25),
                      label: Text("Detail Item", style: titleTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: PageView(
            reverse: true,
            controller: pageControllerBottom,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 0,
                ),
                children: [
                  customTextField("Nama Item", namaItemController),
                  const SizedBox(height: 10),
                  customTextField("Kode/Barcode", kodeBarcodeController),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: customTextField("Harga", hargaItemController),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: GestureDetector(
                          onTap: () => setState(() => condiment = !condiment),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 135,
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color:
                                  condiment ? AppColor.primary : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: (condiment
                                          ? Colors.black
                                          : Colors.green)
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
                                    size: 25,
                                  ),
                                ),
                                AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  left: condiment ? 100 : 150,
                                  duration: Duration(milliseconds: 500),
                                  child: Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  top: 2,
                                  left: condiment ? -100 : 38,
                                  duration: Duration(milliseconds: 500),
                                  child: Text("Normal", style: lv1TextStyle),
                                ),
                                AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  left: condiment ? 10 : 150,
                                  top: 2,
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<ModelKategori>(
                            style: lv05TextStyle,
                            decoration: InputDecoration(
                              label: Text(
                                "Pilih Kategori",
                                style: lv1TextStyle,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            hint: Text(
                              selectedkategori ?? "Kategori..",
                              style: lv1TextStyle,
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
                            style: lv1TextStyleDisable,
                            enabled: false,
                            controller: cabangItemController,
                            decoration: const InputDecoration(
                              labelText: "Cabang",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            label: Text("Hapus", style: lv1TextStyleWhite),
                            icon: Icon(Icons.delete, color: Colors.white),
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
                                customSnackBar(context, "Data belum lengkap!");
                              } else {
                                String iditem =
                                    iditemUpdate == null
                                        ? Uuid().v4()
                                        : iditemUpdate!;
                                final item = ModelItem(
                                  uidUser: uidUser!,
                                  namaItem: namaItemController.text,
                                  idItem: iditem,
                                  hargaItem: hargaItemController.text,
                                  idKategoriItem: selectedIdkategori!,
                                  statusCondiment: false,
                                  urlGambar: "",
                                  qtyItem: 0,
                                  idCabang: selectedIDcabang!,
                                  barcode: kodeBarcodeController.text,
                                );
                                item.pushORupdateData(iditem);
                                _reset();
                              }
                            },
                            label: Text("Simpan", style: lv1TextStyleWhite),
                            icon: Icon(Icons.save, color: Colors.white),
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
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: customTextField(
                          "Nama Kategori",
                          namaKategoriController,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          enabled: false,
                          controller: cabangItemController,
                          decoration: const InputDecoration(
                            labelText: "Cabang",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        String idkategori =
                            idkategoriUpdate == null
                                ? Uuid().v4()
                                : idkategoriUpdate!;

                        Map<String, dynamic> pushKategori = {
                          "nama_kategori": namaKategoriController.text,
                          "id_kategori": idkategori,
                          "uid_user": uidUser,
                          "id_cabang": selectedIDcabang,
                        };
                        FirebaseFirestore.instance
                            .collection("kategori")
                            .doc(idkategori)
                            .set(pushKategori);

                        namaKategoriController.clear();
                        idkategoriUpdate = null;
                        _initKategori();
                      },
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.white,
                        backgroundColor: AppColor.primary,
                      ),
                      icon: Icon(Icons.check),
                      label: Text("Simpan", style: lv1TextStyleWhite),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "PANDUAN:\nUntuk hapus Kategori, silahkan klik dan tahan Kategori yang diinginkan",
                        style: lv05TextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
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
      style: lv05TextStyle,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(text, style: lv05TextStyle),
        hint: Text("$text...", style: lv05TextStyle),
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget rowContentAnim(Icon iconContent, Text textCOntent) {
    return Row(children: [iconContent, textCOntent]);
  }

  Widget anim(
    bool swap,
    VoidCallback callback,
    Widget text1,
    Widget text2,
    double width,
    double height,
  ) {
    return GestureDetector(
      onTap: callback,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: width,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        height: height,
        child: Stack(
          children: [
            AnimatedPositioned(
              curve: Curves.easeInOut,
              left: swap ? -width : 0,
              top: 4,
              duration: Duration(milliseconds: 500),
              child: text2,
            ),
            AnimatedPositioned(
              curve: Curves.easeInOut,
              left: swap ? 0 : width + (width / 2),
              top: 4,
              duration: Duration(milliseconds: 500),
              child: Align(alignment: Alignment.centerLeft, child: text1),
            ),
          ],
        ),
      ),
    );
  }

  void _reset() async {
    iditemUpdate = null;
    idkategoriUpdate = null;
    namaItemController.clear();
    hargaItemController.clear();
    kodeBarcodeController.clear();
    await _initItem();
  }
}
