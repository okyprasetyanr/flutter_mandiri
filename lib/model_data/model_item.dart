import 'package:cloud_firestore/cloud_firestore.dart';

class ModelItem {
  final String _namaItem,
      _idItem,
      _hargaItem,
      _idKategoriItem,
      _urlGambar,
      _qtyItem,
      _idCabang;
  final bool _statusCondiment;

  ModelItem({
    required String namaItem,
    required String idItem,
    required String hargaItem,
    required String idKategoriItem,
    required bool statusCondiment,
    required String urlGambar,
    required String qtyItem,
    required String idCabang,
  }) : _namaItem = namaItem,
       _idItem = idItem,
       _hargaItem = hargaItem,
       _idKategoriItem = idKategoriItem,
       _statusCondiment = statusCondiment,
       _urlGambar = urlGambar,
       _qtyItem = qtyItem,
       _idCabang = idCabang;

  String get getnamaItem => _namaItem;
  String get getidItem => _idItem;
  String get gethargaItem => _hargaItem;
  String get getidKategoriItem => _idKategoriItem;
  bool get getstatusCondiment => _statusCondiment;
  String get geturlGambar => _urlGambar;
  String get getqtyitem => _qtyItem;
  String get getidCabang => _idCabang;

  set setnamaItem(String value) => _namaItem;
  set setidItem(String value) => _idItem;
  set sethargaItem(String value) => _hargaItem;
  set setidKategoriItem(String value) => _idKategoriItem;
  set setstatusCondiment(bool value) => _statusCondiment;
  set seturlGambar(String value) => _urlGambar;
  set setqtyItem(String value) => _qtyItem;
  set setidCabng(String value) => _idCabang;

  Map<String, dynamic> convertToMap() {
    return {
      'nama_item': getnamaItem,
      'harga_item': gethargaItem,
      'id_item': getidItem,
      'id_kategori': getidKategoriItem,
      'status_condiment': getstatusCondiment,
      'url_gambar': geturlGambar,
      'qty_item': getqtyitem,
      'id_cabang': getidCabang,
    };
  }

  Future<void> pushData(String uidUser) async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(uidUser)
        .collection("items")
        .doc(getidItem)
        .set(convertToMap());
  }

  static List<ModelItem> getDataListItem(QuerySnapshot data) {
    return data.docs.map((map) {
      final dataitem = map.data() as Map<String, dynamic>;
      return ModelItem(
        namaItem: dataitem['nama_item'],
        idItem: map.id,
        hargaItem: dataitem['harga_item'],
        idKategoriItem: dataitem['id_kategori'],
        statusCondiment: dataitem['status_condiment'],
        urlGambar: dataitem['url_gambar'],
        qtyItem: dataitem['qty_item'],
        idCabang: dataitem['id_cabang'],
      );
    }).toList();
  }
}
