import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/function/function.dart';
import 'package:flutter_mandiri/model_data/model_item.dart';
import 'package:flutter_mandiri/model_data/model_item_pesanan.dart';
import 'package:flutter_mandiri/screens/screen_adjustment.dart';
import 'package:flutter_mandiri/screens/screen_sales.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_standart.dart';
import 'package:flutter_mandiri/widget/widget_navigation_gesture.dart';
import 'package:flutter_mandiri/widget/widget_snack_bar.dart';

class ScreenBuy extends StatefulWidget {
  const ScreenBuy({super.key});

  @override
  State<ScreenBuy> createState() => _ScreenBuyState();
}

class _ScreenBuyState extends State<ScreenBuy> {
  final List<Map<String, dynamic>> contentNavGesture = [
    {
      "id": "sale",
      "toContext": ScreenSale(),
      "text_menu": "Penjualan",
      "onTap": () {},
    },
    {
      "id": "buy",
      "toContext": ScreenBuy(),
      "text_menu": "Pembelian",
      "onTap": () {},
    },
    {
      "id": "adjustment",
      "toContext": ScreenAdjustment(),
      "text_menu": "Adjustment",
      "onTap": () {},
    },
  ];

  String? uidUser;
  bool isOpen = false;
  int gridviewcount = 0;
  List<ModelItem> listItem = [];
  List<ModelItemPesanan> listItemPesanan = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupData();
    });
  }

  Future<void> _setupData() async {
    await _initItem();
  }

  Future<void> _initItem() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance
            .collection("items")
            // .where('status_condiment', isEqualTo: checkcondiment)
            // .where('id_cabang', isEqualTo: selectedIDcabang)
            .where('uid_user', isEqualTo: UserSession.uidUser!)
            .orderBy("nama_item", descending: true)
            .get();
    if (!mounted) return;
    debugPrint("UID belum siap, skip fetch item");
    setState(() {
      if (data.size > 0) {
        List<ModelItem> item = ModelItem.getDataListItem(data);
        listItem = item;
      } else {
        listItem.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    gridviewcount = 4;
    return LayoutTopBottom(
      widgetTop: layoutTop(),
      widgetBottom: layoutBottom(),
      widgetNavigation: navigationGesture(),
    );
  }

  Widget layoutTop() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                customSnackBar(context, "${listItem.length}");
                setState(() {
                  isOpen = !isOpen;
                });
              },
              icon: Icon(Icons.menu),
              label: Text("Menu"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text("Pembelian", style: titleTextStyle),
            ),
          ],
        ),

        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  alignLabelWithHint: false,
                  label: Text("Search", style: lv1TextStyle),
                  hintText: "Search...",
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
          ],
        ),
        Flexible(
          child: GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: listItem.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridviewcount,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    final item = ModelItemPesanan(
                      namaItem: listItem[index].getnamaItem,
                      idItem: listItem[index].getidItem,
                      qtyItem: "1",
                      hargaItem: listItem[index].gethargaItem,
                      diskonItem: "0",
                      idKategoriItem: listItem[index].getidKategoriItem,
                      idCondimen: "",
                      catatan: "",
                      urlGambar: listItem[index].geturlGambar,
                    );
                    setState(() {
                      listItemPesanan.add(item);
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
                          child: Center(child: Image.asset("assets/logo.png")),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Widget layoutBottom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text("List Pesanan", style: titleTextStyle),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listItemPesanan.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: ShaderMask(
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
                      stops: [0, 0.03, 0.97, 1],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          index % 2 == 0
                              ? const Color.fromARGB(255, 235, 235, 235)
                              : const Color.fromARGB(255, 221, 221, 221),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              listItemPesanan[index].geturlGambar,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/logo.png",
                                  width: 40,
                                  height: 40,
                                );
                              },
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${listItemPesanan[index].getqtyItem}x",
                                      style: lv05TextStyle,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      listItemPesanan[index].getnamaItem,
                                      style: lv05TextStyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  "Catatan: ${listItemPesanan[index].getcatatan}",
                                  style: lv0TextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              formatUang(listItemPesanan[index].gethargaItem),
                              style: lv05TextStyle,
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white),
              backgroundColor: WidgetStatePropertyAll(AppColor.primary),
            ),
            onPressed: () {},
            label: Text("Bayar", style: lv1TextStyleWhite),
            icon: Icon(Icons.attach_money_rounded),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget navigationGesture() {
    return NavigationGesture(
      currentPage: "buy",
      attContent: contentNavGesture,
      isOpen: isOpen,
      close: () {
        setState(() {
          isOpen = false;
        });
      },
    );
  }
}
