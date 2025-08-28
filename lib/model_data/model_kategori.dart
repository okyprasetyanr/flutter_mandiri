import 'package:cloud_firestore/cloud_firestore.dart';

class ModelKategori {
  String _namaKategori, _idkategori;
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
}
