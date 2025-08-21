import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String namaPerusahaan, noTelpPerusahaan, bergabung;
  UserModel({
    required this.namaPerusahaan,
    required this.noTelpPerusahaan,
    required this.bergabung,
  });

  factory UserModel.getFirestore(DocumentSnapshot data) {
    Map dataUser = data.data() as Map<String, dynamic>;
    return UserModel(
      namaPerusahaan: dataUser['nama_perusahaan'],
      noTelpPerusahaan: dataUser['no_telp_perusahaan'],
      bergabung: dataUser['bergabung'],
    );
  }
}
