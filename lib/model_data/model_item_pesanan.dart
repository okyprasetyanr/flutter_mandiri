class ModelItemPesanan {
  final String _namaItem,
      _idItem,
      _qtyItem,
      _hargaItem,
      _diskonItem,
      _idKategoriItem,
      _idCondimen,
      _catatan,
      _urlGambar;

  ModelItemPesanan({
    required String namaItem,
    required String idItem,
    required String qtyItem,
    required String hargaItem,
    required String diskonItem,
    required String idKategoriItem,
    required String idCondimen,
    required String catatan,
    required String urlGambar,
  }) : _namaItem = namaItem,
       _idItem = idItem,
       _qtyItem = qtyItem,
       _hargaItem = hargaItem,
       _diskonItem = diskonItem,
       _idKategoriItem = idKategoriItem,
       _idCondimen = idCondimen,
       _catatan = catatan,
       _urlGambar = urlGambar;

  String get getnamaItem => _namaItem;
  String get getidItem => _idItem;
  String get getqtyItem => _qtyItem;
  String get gethargaItem => _hargaItem;
  String get getdiskonItem => _diskonItem;
  String get getidKategoriItem => _idKategoriItem;
  String get getidCondimen => _idCondimen;
  String get getcatatan => _catatan;
  String get geturlGambar => _urlGambar;

  set setnamaItem(String value) => _namaItem;
  set setidItem(String value) => _idItem;
  set setqtyItem(String value) => _qtyItem;
  set sethargaItem(String value) => _hargaItem;
  set setdiskonItem(String value) => _diskonItem;
  set setidKategoriItem(String value) => _idKategoriItem;
  set setidCondimen(String value) => _idCondimen;
  set setcatatan(String value) => _catatan;
  set seturlGambar(String value) => _urlGambar;
}
