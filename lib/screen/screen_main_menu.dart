import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getNamaPerusahaan();
  }

  Future<void> getNamaPerusahaan() async {
    final pref = await SharedPreferences.getInstance();
    DocumentSnapshot data =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(pref.getString("uid_user"))
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
        widgetTop: LayoutTop(),
        widgetBottom: LayoutBottom(),
        namaPerusahaan: namaPerusahaan ?? "Mohon Tunggu",
      ),
    );
  }
}

Widget LayoutBottom() {
  return Text("");
}

Widget LayoutTop() {
  return Text("");
}
