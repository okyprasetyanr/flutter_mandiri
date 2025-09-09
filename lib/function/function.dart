import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatUang(String nominal) {
  final nominalfinal = nominal
      .replaceAll("R", "")
      .replaceAll(".", "")
      .replaceAll(",", "")
      .replaceAll("R", "");
  final format = NumberFormat.currency(
    locale: 'id',
    decimalDigits: 2,
    symbol: 'Rp',
  );
  final convertnominal = double.tryParse(nominalfinal);
  return format.format(convertnominal);
}

String formatQty(double qty) {
  final format = NumberFormat("##.##");
  return format.format(qty);
}

Map<String, dynamic> convertToMap(Widget toContext, String text) {
  return {'toContext': toContext, 'text_menu': text};
}

class UserSession {
  static String? uidUser;

  static Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    uidUser = pref.getString("uid_user");
  }

  static String? ambilUidUser() {
    return uidUser; // boleh null
  }
}
