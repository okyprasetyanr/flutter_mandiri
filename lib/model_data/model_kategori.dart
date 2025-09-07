import 'package:cloud_firestore/cloud_firestore.dart';

class ModelKategori {
  final String _namaKategori, _idkategori;
  ModelKategori({required String namaKategori, required String idkategori})
    : _namaKategori = namaKategori,
      _idkategori = idkategori;

  Map<String, dynamic> convertMap() {
    return {'nama_kategori': _namaKategori, 'id_kategori': _idkategori};
  }

  String get getnamaKategori => _namaKategori;
  String get getidKategori => _idkategori;

  set setnamKategori(String value) => _namaKategori;
  set setidKategori(String value) => _idkategori;

  Map<String, dynamic> convertToMap() {
    return {'nama_kategori': getnamaKategori, 'id_kategori': getidKategori};
  }

  Future<void> pushData(String uidUser) async {
    await FirebaseFirestore.instance.collection("kategori").add(convertToMap());
  }

  static List<ModelKategori> getDataListKategori(QuerySnapshot data) {
    return data.docs.map((map) {
      final dataKetegori = map.data() as Map<String, dynamic>;
      return ModelKategori(
        namaKategori: dataKetegori['nama_kategori'],
        idkategori: map.id,
      );
    }).toList();
  }
}
