import 'package:cloud_firestore/cloud_firestore.dart';

class ModelCabang {
  final String _daerahCabang, _nomorCabang, _alamatCabang, _idCabang;
  ModelCabang({
    required String daerahCabang,
    required String nomorCabang,
    required String alamatCabang,
    required String idCabang,
  }) : _daerahCabang = daerahCabang,
       _nomorCabang = nomorCabang,
       _alamatCabang = alamatCabang,
       _idCabang = idCabang;

  String get getdaerahCabang => _daerahCabang;
  String get getnomorCabang => _nomorCabang;
  String get getalamatCabang => _alamatCabang;
  String get getidCabang => _idCabang;

  set setdaerahCabang(String value) => _daerahCabang;
  set setnomorCabang(String value) => _nomorCabang;
  set setalamatCabang(String value) => _alamatCabang;
  set setidCabang(String value) => _alamatCabang;

  static List<ModelCabang> getDataListCabang(DocumentSnapshot data) {
    Map dataUser = data.data() as Map<String, dynamic>;
    List listcabang = dataUser['cabang'] ?? [];
    return listcabang
        .map(
          (map) => ModelCabang(
            daerahCabang: map['daerah_cabang'],
            nomorCabang: map['no_telephone_cabang'],
            alamatCabang: map['alamat_cabang'],
            idCabang: map['id_cabang'],
          ),
        )
        .toList();
  }
}
