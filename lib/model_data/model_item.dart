import 'package:cloud_firestore/cloud_firestore.dart';

class ModelItem {
  final String _uidUser,
      _namaItem,
      _idItem,
      _hargaItem,
      _idKategoriItem,
      _urlGambar,
      _idCabang,
      _barcode;
  final double _qtyItem;
  final bool _statusCondiment;

  ModelItem({
    required String uidUser,
    required String namaItem,
    required String idItem,
    required String hargaItem,
    required String idKategoriItem,
    required bool statusCondiment,
    required String urlGambar,
    required double qtyItem,
    required String idCabang,
    required String barcode,
  }) : _uidUser = uidUser,
       _namaItem = namaItem,
       _idItem = idItem,
       _hargaItem = hargaItem,
       _idKategoriItem = idKategoriItem,
       _statusCondiment = statusCondiment,
       _urlGambar = urlGambar,
       _qtyItem = qtyItem,
       _idCabang = idCabang,
       _barcode = barcode;

  String get getuidUser => _uidUser;
  String get getnamaItem => _namaItem;
  String get getidItem => _idItem;
  String get gethargaItem => _hargaItem;
  String get getidKategoriItem => _idKategoriItem;
  bool get getstatusCondiment => _statusCondiment;
  String get geturlGambar => _urlGambar;
  double get getqtyitem => _qtyItem;
  String get getidCabang => _idCabang;
  String get getBarcode => _barcode;

  set setuidUser(String value) => _uidUser;
  set setnamaItem(String value) => _namaItem;
  set setidItem(String value) => _idItem;
  set sethargaItem(String value) => _hargaItem;
  set setidKategoriItem(String value) => _idKategoriItem;
  set setstatusCondiment(bool value) => _statusCondiment;
  set seturlGambar(String value) => _urlGambar;
  set setqtyItem(double value) => _qtyItem;
  set setidCabng(String value) => _idCabang;
  set setBarcode(String value) => _barcode;

  Map<String, dynamic> convertToMap() {
    return {
      'uid_user': getuidUser,
      'nama_item': getnamaItem,
      'harga_item': gethargaItem,
      'id_item': getidItem,
      'id_kategori': getidKategoriItem,
      'status_condiment': getstatusCondiment,
      'url_gambar': geturlGambar,
      'qty_item': getqtyitem,
      'id_cabang': getidCabang,
      'barcode': getBarcode,
    };
  }

  Future<void> pushORupdateData(String idItem) async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(idItem)
        .set(convertToMap());
  }

  static List<ModelItem> getDataListItem(QuerySnapshot data) {
    return data.docs.map((map) {
      final dataItem = map.data() as Map<String, dynamic>;
      return ModelItem(
        uidUser: dataItem['uid_user'],
        namaItem: dataItem['nama_item'],
        idItem: map.id,
        hargaItem: dataItem['harga_item'],
        idKategoriItem: dataItem['id_kategori'],
        statusCondiment: dataItem['status_condiment'],
        urlGambar: dataItem['url_gambar'],
        qtyItem: dataItem['qty_item'].toDouble(),
        idCabang: dataItem['id_cabang'],
        barcode: dataItem['barcode'],
      );
    }).toList();
  }
}
