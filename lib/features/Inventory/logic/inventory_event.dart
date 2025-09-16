import 'package:flutter_mandiri/model_data/model_item.dart';

abstract class InventoryEvent {}

class LoadCabang extends InventoryEvent {}

class LoadKategori extends InventoryEvent {
  final String idCabang;
  LoadKategori(this.idCabang);
}

class LoadItems extends InventoryEvent {
  final String idCabang;
  final bool checkCondiment;
  final String keySortir;
  final bool descending;
  LoadItems(
    this.idCabang,
    this.checkCondiment,
    this.keySortir,
    this.descending,
  );
}

class AddItem extends InventoryEvent {
  final ModelItem item;
  AddItem(this.item);
}

class UpdateItem extends InventoryEvent {
  final ModelItem item;
  UpdateItem(this.item);
}

class DeleteItem extends InventoryEvent {
  final String idItem;
  DeleteItem(this.idItem);
}
