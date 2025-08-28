import 'package:cloud_firestore/cloud_firestore.dart';

class ModelItem {
  String _Nama_item, _Id_item, _Harga_item, _Id_kategori_item, _Url_gambar;
  bool _Status_condiment;

  ModelItem({
    required String namaItem,
    required String idItem,
    required String hargaItem,
    required String idKategoriItem,
    required bool statusCondiment,
    required String urlGambar,
  }) : _Nama_item = namaItem,
       _Id_item = idItem,
       _Harga_item = hargaItem,
       _Id_kategori_item = idKategoriItem,
       _Status_condiment = statusCondiment,
       _Url_gambar = urlGambar;

  String get getnamaItem => _Nama_item;
  String get getidItem => _Id_item;
  String get gethargaItem => _Harga_item;
  String get getidKategoriItem => _Id_kategori_item;
  bool get getstatusCondiment => _Status_condiment;
  String get geturlGambar => _Url_gambar;

  set setnamaItem(String value) => _Nama_item;
  set setidItem(String value) => _Id_item;
  set sethargaItem(String value) => _Harga_item;
  set setidKategoriItem(String value) => _Id_kategori_item;
  set setstatusCondiment(bool value) => _Status_condiment;
  set seturlGambar(String value) => _Url_gambar;

  Map<String, dynamic> convertToMap() {
    return {
      'nama_item': getnamaItem,
      'harga_item': gethargaItem,
      'id_item': getidItem,
      'id_kategory': getidKategoriItem,
      'status_condiment': getstatusCondiment,
      'url_gambar': geturlGambar,
    };
  }

  Future<void> pushData(String uidUser) async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(uidUser)
        .collection("user_item")
        .doc(getidItem)
        .set(convertToMap());
  }
}
