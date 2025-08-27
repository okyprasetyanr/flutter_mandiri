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

  String get namaItem => _Nama_item;
  String get idItem => _Id_item;
  String get qtyItem => _Qty_item;
  String get hargaItem => _Harga_item;
  String get diskonItem => _Diskon_item;
  String get idKategoriItem => _Id_kategori_item;
  String get idCondimen => _Id_condimen;
  String get urlGambar => _Url_gambar;

  set namaItem(String value) => _Nama_item;
  set idItem(String value) => _Id_item;
  set qtyItem(String value) => _Qty_item;
  set hargaItem(String value) => _Harga_item;
  set diskonItem(String value) => _Diskon_item;
  set idKategoriItem(String value) => _Id_kategori_item;
  set idCondimen(String value) => _Id_condimen;
  set urlGambar(String value) => _Url_gambar;
}
