import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mandiri/function/function.dart';
import 'package:flutter_mandiri/screens/screen_inventory.dart';
import 'package:flutter_mandiri/screens/screen_sales.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/style_and_transition/transition_navigator/transition_UpDown.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_main_menu.dart';

class ScreenMainMenu extends StatefulWidget {
  const ScreenMainMenu({super.key});

  @override
  State<ScreenMainMenu> createState() => _ScreenMainMenuState();
}

class _ScreenMainMenuState extends State<ScreenMainMenu> {
  String? namaPerusahaan;
  @override
  void initState() {
    super.initState();
    initUserSession();
  }

  Future<void> initUserSession() async {
    await UserSession.init();
    getNamaPerusahaan();
  }

  Future<void> getNamaPerusahaan() async {
    await UserSession.ambilUidUser();
    DocumentSnapshot data =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(UserSession.ambilUidUser())
            .get();
    if (data.exists) {
      setState(() {
        namaPerusahaan = data['nama_perusahaan'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutTopBottomMainMenu(
        widgetTop: layoutTop(context),
        widgetBottom: layoutBottom(),
        namaPerusahaan: namaPerusahaan ?? "Mohon Tunggu",
      ),
    );
  }
}

Widget layoutTop(BuildContext context) {
  return GridView.count(
    crossAxisCount: 3,
    padding: EdgeInsets.all(10),
    shrinkWrap: true,
    childAspectRatio: 1,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,

    children: [
      gridViewMenu(
        () {
          navUpDownTransition(context, ScreenInventory(), false);
        },
        Icon(Icons.inventory),
        "Inventoryi",
      ),
      gridViewMenu(
        () {
          navUpDownTransition(context, ScreenSale(), false);
        },
        Icon(Icons.shopping_cart),
        "Transaksi",
      ),
      gridViewMenu(() {}, Icon(Icons.assignment_outlined), "Laporan"),
    ],
  );
}

Widget layoutBottom() {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.4),
            offset: Offset(0, 0),
            spreadRadius: 10,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Penjualan"),
              Text("Total Diskon"),
              Text("Total PPN"),
              Text("Penjualan Bersih"),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Text("Rp.0"), Text("Rp.0"), Text("Rp.0"), Text("Rp.0")],
          ),
        ],
      ),
    ),
  );
}

Widget gridViewMenu(VoidCallback onPressed, Icon icon, String text) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    onPressed: onPressed,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        const SizedBox(height: 5),
        Text(text, style: lv1TextStyle),
      ],
    ),
  );
}
