import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/model_data/model_account.dart';
import 'package:flutter_mandiri/widget_and_style/style/style_font_&_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  String? namaPerusahaan;

  @override
  void initState() {
    super.initState();
    initPref();
  }

  Future<void> initPref() async {
    final pref = await SharedPreferences.getInstance();
    DocumentSnapshot data =
        await FirebaseFirestore.instance
            .collection("users")
            .doc("${pref.getString("uid_user")}")
            .get();
    if (data.exists) {
      setState(() {
        namaPerusahaan = UserModel.getFirestore(data).namaPerusahaan;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: AppColor.primary),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  child: Image.asset("assets/logo.png", width: 50, height: 50),
                ),
                Positioned(
                  left: 65,
                  top: 55,
                  child: Text("Aplikasi Ku!", style: labelTextStyle),
                ),
                Positioned(
                  top: 95,
                  child: SizedBox(
                    child: Text(
                      "Welcome $namaPerusahaan!",
                      style: lv2TextStyle,
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  child: SizedBox(
                    child: Text(
                      "Mau ngapain nih hari ini?",
                      style: lv1TextStyle,
                    ),
                  ),
                ),
                Positioned(
                  top: 160,
                  left: 0,
                  right: 0,
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      if (orientation == Orientation.portrait) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildGridMenu(),
                            SizedBox(height: 8),
                            buildReportSection(),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(flex: 1, child: buildGridMenu()),
                            Expanded(flex: 1, child: buildReportSection()),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridMenu() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        buildMenuButton(Icons.inventory, "Inventory"),
        buildMenuButton(Icons.shopping_bag, "Transaksi"),
        buildMenuButton(Icons.point_of_sale, "Laporan"),
      ],
    );
  }

  Widget buildReportSection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 35,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Penjualan Hari ini",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Penjualan"),
                      Text("Total Diskon"),
                      Text("Total PPN"),
                      Text("Penjualan Bersih"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Rp.0"),
                      Text("Rp.0"),
                      Text("Rp.0"),
                      Text("Rp.0"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(IconData icon, String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(8),
        elevation: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36),
          SizedBox(height: 8),
          Text(label, style: labelTextStyle),
        ],
      ),
    );
  }
}
