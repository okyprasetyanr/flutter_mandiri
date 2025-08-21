import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/widget_and_style/style/style_font_&_size.dart';
import 'package:flutter_mandiri/widget_and_style/widget/widget_custom.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final DatabaseReference databaseref = FirebaseDatabase.instance.ref();
  TextEditingController password = TextEditingController();
  TextEditingController namaperusahaan = TextEditingController();
  TextEditingController emailperusahaan = TextEditingController();
  TextEditingController notelephoneperusahaan = TextEditingController();
  List<TextEditingController> daerahcabang = [];
  List<TextEditingController> alamatcabang = [];
  List<TextEditingController> notelephone = [];
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? selectedcabang = "1";
  @override
  void dispose() {
    password.dispose();
    namaperusahaan.dispose();
    emailperusahaan.dispose();
    notelephoneperusahaan.dispose();
    for (var c in daerahcabang) {
      c.dispose();
    }
    for (var c in alamatcabang) {
      c.dispose();
    }
    for (var c in notelephone) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (selectedcabang != null) {
      int totalcabang = int.tryParse(selectedcabang!) ?? 1;
      for (int i = 0; i < totalcabang; i++) {
        daerahcabang.add(TextEditingController());
        alamatcabang.add(TextEditingController());
        notelephone.add(TextEditingController());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthscreen = MediaQuery.of(context).size.width;
    List<String> days = List.generate(31, (index) => '${index + 1}');
    List<String> months = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
    ];
    final formKey = GlobalKey<FormState>();
    List<String> cabang = ["1", "2", "3"];
    List<String> years = List.generate(100, (index) => '${2025 - index}');
    selectedcabang ??= "1";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Sign-Up",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text("Form Pendaftaran", style: titleTextStyle),
                    ),
                    SizedBox(height: 30),
                    // Username
                    SizedBox(
                      width: widthscreen * 0.7,
                      child: customTextField(
                        "E-mail",
                        "email@...",
                        emailperusahaan,
                        validator: (value) => null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: widthscreen * 0.7,
                      child: customTextField(
                        "Password",
                        "Password...",
                        password,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isNotEmpty && value.length < 8) {
                            return "Minimal 8 karakter!";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Tanggal bergabung",
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        // Tanggal
                        Expanded(
                          child: Material(
                            shadowColor: Colors.black,
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedDay,
                              hint: Text("Tanggal", style: hintTextStyle),
                              items:
                                  days
                                      .map(
                                        (d) => DropdownMenuItem(
                                          value: d,
                                          child: Text(d),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => selectedDay = value),
                              decoration: InputDecoration(
                                labelText: "Tanggal",
                                labelStyle: labelTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),

                        // Bulan
                        Expanded(
                          child: Material(
                            shadowColor: Colors.black,
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedMonth,
                              hint: Text("Bulan", style: hintTextStyle),
                              items:
                                  months
                                      .map(
                                        (m) => DropdownMenuItem(
                                          value: m,
                                          child: Text(m),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => selectedMonth = value),
                              decoration: InputDecoration(
                                labelText: "Bulan",
                                labelStyle: labelTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),

                        // Tahun
                        Expanded(
                          child: Material(
                            shadowColor: Colors.black,
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedYear,
                              hint: Text("Tahun", style: hintTextStyle),
                              items:
                                  years
                                      .map(
                                        (y) => DropdownMenuItem(
                                          value: y,
                                          child: Text(y),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => selectedYear = value),
                              decoration: InputDecoration(
                                labelText: "Tahun",
                                labelStyle: labelTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customTextField(
                                  "Nama Perusahaan",
                                  "Perusahaan...",
                                  namaperusahaan,
                                  validator: (value) => null,
                                  keyboardType: TextInputType.none,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    IntrinsicWidth(
                                      stepWidth: 40,
                                      child: Material(
                                        shadowColor: Colors.black,
                                        elevation: 4,
                                        borderRadius: BorderRadius.circular(15),
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: false,
                                          value: selectedcabang,
                                          hint: Center(
                                            child: Text(
                                              "$selectedcabang",
                                              style: hintTextStyle,
                                            ),
                                          ),
                                          items:
                                              cabang
                                                  .map(
                                                    (m) => DropdownMenuItem(
                                                      value: m,
                                                      child: Center(
                                                        child: Text(m),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedcabang = value;
                                              int total =
                                                  int.tryParse(value ?? "0") ??
                                                  0;
                                              daerahcabang = List.generate(
                                                total,
                                                (_) => TextEditingController(),
                                              );
                                              alamatcabang = List.generate(
                                                total,
                                                (_) => TextEditingController(),
                                              );
                                              notelephone = List.generate(
                                                total,
                                                (_) => TextEditingController(),
                                              );
                                            });
                                          },

                                          decoration: InputDecoration(
                                            labelText: "Cabang",
                                            labelStyle: labelTextStyle,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: customTextField(
                                        "No. Telephone",
                                        "08...",
                                        notelephoneperusahaan,
                                        validator: (value) => null,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),

                                Column(
                                  children: List.generate(
                                    int.tryParse(selectedcabang ?? "1") ?? 1,
                                    (index) => CustomDropDownCabang(
                                      i: index + 1,
                                      daerahcabang: daerahcabang[index],
                                      alamatcabang: alamatcabang[index],
                                      notelephone: notelephone[index],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.white,
                            child: Text(
                              "Informasi Merchant",
                              style: GoogleFonts.poppins(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 30,
              child: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  backgroundColor: AppColor.primary,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                              email: emailperusahaan.text,
                              password: password.text,
                            );

                        if (!mounted) return;

                        String iduser = userCredential.user!.uid;

                        final ref = FirebaseFirestore.instance.collection(
                          "users",
                        );
                        int totalcabang = int.tryParse(selectedcabang!) ?? 1;
                        List<Map<String, dynamic>> mapCabang = [];

                        for (int i = 0; i < totalcabang; i++) {
                          mapCabang.add({
                            "daerah_cabang": daerahcabang[i].text,
                            "alamat_cabang": alamatcabang[i].text,
                            "no_telephone_cabang": notelephone[i].text,
                          });
                        }

                        await ref.doc(iduser).set({
                          "nama_perusahaan": namaperusahaan.text,
                          "no_telp_perusahaan": notelephoneperusahaan.text,
                          "bergabung":
                              "$selectedDay/$selectedMonth/$selectedYear",
                          "cabang": mapCabang,
                        });

                        if (!mounted) return;
                        Navigator.pop(context);
                      } catch (error) {
                        if (!mounted) return;
                        customSnackBar(context, "Gagal Daftar: $error");
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
