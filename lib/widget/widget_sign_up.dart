import 'package:flutter/material.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customTextField(
  String label,
  String hint,
  TextEditingController controller, {
  required TextInputType keyboardType,
  required String? Function(dynamic value) validator,
}) {
  return Material(
    elevation: 4,
    shadowColor: Colors.black,
    borderRadius: BorderRadius.circular(15),
    child: TextFormField(
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelStyle: labelTextStyle,
        labelText: label,
        hintStyle: hintTextStyle,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}

class CustomDropDownCabang extends StatelessWidget {
  final int i;
  final TextEditingController daerahcabang;
  final TextEditingController alamatcabang;
  final TextEditingController notelephone;

  const CustomDropDownCabang({
    super.key,
    required this.i,
    required this.daerahcabang,
    required this.alamatcabang,
    required this.notelephone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Cabang $i", style: GoogleFonts.poppins(fontSize: 20)),
            customTextField(
              "Daerah Cabang",
              "Masukkan daerah...",
              daerahcabang,
              validator: (value) => null,
              keyboardType: TextInputType.none,
            ),
            SizedBox(height: 10),
            customTextField(
              "Alamat Cabang",
              "Masukkan alamat...",
              alamatcabang,
              validator: (value) => null,
              keyboardType: TextInputType.none,
            ),
            SizedBox(height: 10),
            customTextField(
              "No. Telepon",
              "Masukkan no telepon...",
              notelephone,
              validator: (value) => null,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
