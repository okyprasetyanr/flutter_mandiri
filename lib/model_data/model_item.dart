import 'package:cloud_firestore/cloud_firestore.dart';

class ModelItem {
  final String _namaItem,
      _idItem,
      _hargaItem,
      _idKategoriItem,
      _urlGambar,
      _qtyItem;
  final bool _statusCondiment;

  ModelItem({
    required String namaItem,
    required String idItem,
    required String hargaItem,
    required String idKategoriItem,
    required bool statusCondiment,
    required String urlGambar,
    required String qtyItem,
  }) : _namaItem = namaItem,
       _idItem = idItem,
       _hargaItem = hargaItem,
       _idKategoriItem = idKategoriItem,
       _statusCondiment = statusCondiment,
       _urlGambar = urlGambar,
       _qtyItem = qtyItem;

  String get getnamaItem => _namaItem;
  String get getidItem => _idItem;
  String get gethargaItem => _hargaItem;
  String get getidKategoriItem => _idKategoriItem;
  bool get getstatusCondiment => _statusCondiment;
  String get geturlGambar => _urlGambar;
  String get getqtyitem => _qtyItem;

  set setnamaItem(String value) => _namaItem;
  set setidItem(String value) => _idItem;
  set sethargaItem(String value) => _hargaItem;
  set setidKategoriItem(String value) => _idKategoriItem;
  set setstatusCondiment(bool value) => _statusCondiment;
  set seturlGambar(String value) => _urlGambar;
  set setqtyItem(String value) => _qtyItem;

  Map<String, dynamic> convertToMap() {
    return {
      'nama_item': getnamaItem,
      'harga_item': gethargaItem,
      'id_item': getidItem,
      'id_kategory': getidKategoriItem,
      'status_condiment': getstatusCondiment,
      'url_gambar': geturlGambar,
      'qty_item': getqtyitem,
    };
  }

  Future<void> pushData(String uidUser, String idcabang) async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(uidUser)
        .collection(idcabang)
        .doc("item")
        .set(convertToMap());
  }

  static List<ModelItem> getDataListItem(DocumentSnapshot data) {
    Map dataitem = data.data() as Map<String, dynamic>;
    List listitem = dataitem['item'];
    return listitem
        .map(
          (map) => ModelItem(
            namaItem: map['nama_item'],
            idItem: map['id_item'],
            hargaItem: map['harga_item'],
            idKategoriItem: map['id_kategori_item'],
            statusCondiment: map['status_condiment'],
            urlGambar: map['url_gambar'],
            qtyItem: map['qty_item'],
          ),
        )
        .toList();
  }
}
