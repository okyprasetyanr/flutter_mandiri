class ModelItemPesanan {
  String _Nama_item,
      _Id_item,
      _Qty_item,
      _Harga_item,
      _Diskon_item,
      _Id_kategori_item,
      _Id_condimen,
      _Url_gambar;

  ModelItemPesanan({
    required String namaItem,
    required String idItem,
    required String qtyItem,
    required String hargaItem,
    required String diskonItem,
    required String idKategoriItem,
    required String idCondimen,
    required String urlGambar,
  }) : _Nama_item = namaItem,
       _Id_item = idItem,
       _Qty_item = qtyItem,
       _Harga_item = hargaItem,
       _Diskon_item = diskonItem,
       _Id_kategori_item = idKategoriItem,
       _Id_condimen = idCondimen,
       _Url_gambar = urlGambar;

  String get getnamaItem => _Nama_item;
  String get getidItem => _Id_item;
  String get getqtyItem => _Qty_item;
  String get gethargaItem => _Harga_item;
  String get getdiskonItem => _Diskon_item;
  String get getidKategoriItem => _Id_kategori_item;
  String get getidCondimen => _Id_condimen;
  String get geturlGambar => _Url_gambar;

  set setnamaItem(String value) => _Nama_item;
  set setidItem(String value) => _Id_item;
  set setqtyItem(String value) => _Qty_item;
  set sethargaItem(String value) => _Harga_item;
  set setdiskonItem(String value) => _Diskon_item;
  set setidKategoriItem(String value) => _Id_kategori_item;
  set setidCondimen(String value) => _Id_condimen;
  set seturlGambar(String value) => _Url_gambar;
}
