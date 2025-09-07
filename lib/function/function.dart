import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
