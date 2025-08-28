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

  static List<ModelKategori> getDataListKategori(DocumentSnapshot data) {
    Map mapdata = data.data() as Map<String, dynamic>;
    List listkategori = mapdata['kategory'] ?? [];
    return listkategori
        .map(
          (map) => ModelKategori(
            namaKategori: map['nama_kategori'],
            idkategori: map['id_kategori'],
          ),
        )
        .toList();
  }
}
