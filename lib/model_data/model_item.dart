class ModelItem {
  String _Nama_item, _Id_item, _Harga_item, _Id_kategori_item, _Url_gambar;
  bool _Status_condimen;

  ModelItem({
    required String namaItem,
    required String idItem,
    required String hargaItem,
    required String idKategoriItem,
    required bool statusCondimen,
    required String urlGambar,
  }) : _Nama_item = namaItem,
       _Id_item = idItem,
       _Harga_item = hargaItem,
       _Id_kategori_item = idKategoriItem,
       _Status_condimen = statusCondimen,
       _Url_gambar = urlGambar;

  String get namaItem => _Nama_item;
  String get idItem => _Id_item;
  String get hargaItem => _Harga_item;
  String get idKategoriItem => _Id_kategori_item;
  bool get statusCondimen => _Status_condimen;
  String get urlGambar => _Url_gambar;

  set namaItem(String value) => _Nama_item;
  set idItem(String value) => _Id_item;
  set hargaItem(String value) => _Harga_item;
  set idKategoriItem(String value) => _Id_kategori_item;
  set statusCondimen(bool value) => _Status_condimen;
  set urlGambar(String value) => _Url_gambar;

  factory ModelItem.pushData(String namaitem, String hargaitem, bool statusCondimen, String urlgambar,) {
    Future
  }
}
