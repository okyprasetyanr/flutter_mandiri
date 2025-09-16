import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mandiri/function/function.dart';
import 'package:flutter_mandiri/model_data/model_cabang.dart';
import 'package:flutter_mandiri/model_data/model_item.dart';
import 'package:flutter_mandiri/model_data/model_kategori.dart';

class InventoryRepository {
  final _db = FirebaseFirestore.instance;

  Future<List<ModelCabang>> fetchCabang() async {
    final data =
        await _db.collection("users").doc(UserSession.ambilUidUser()).get();
    return ModelCabang.getDataListCabang(data);
  }

  Future<List<ModelKategori>> fetchKategori(String idCabang) async {
    final data =
        await _db
            .collection("kategori")
            .where("uid_user", isEqualTo: UserSession.ambilUidUser())
            .where("id_cabang", isEqualTo: idCabang)
            .orderBy("nama_kategori", descending: false)
            .get();
    return ModelKategori.getDataListKategori(data);
  }

  Future<List<ModelItem>> fetchItems(
    String idCabang,
    bool condiment,
    String keySortir,
    bool descending,
  ) async {
    final data =
        await _db
            .collection("items")
            .where('status_condiment', isEqualTo: condiment)
            .where('id_cabang', isEqualTo: idCabang)
            .where('uid_user', isEqualTo: UserSession.ambilUidUser())
            .orderBy(keySortir, descending: descending)
            .get();
    return ModelItem.getDataListItem(data);
  }
}
