import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';

void customSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColor.primary,
    ),
  );
}
