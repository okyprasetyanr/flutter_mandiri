import 'package:flutter_mandiri/model_data/model_cabang.dart';
import 'package:flutter_mandiri/model_data/model_item.dart';
import 'package:flutter_mandiri/model_data/model_kategori.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<ModelCabang> cabangs;
  final List<ModelKategori> kategoris;
  final List<ModelItem> items;

  InventoryLoaded({
    required this.cabangs,
    required this.kategoris,
    required this.items,
  });
}

class InventoryError extends InventoryState {
  final String message;
  InventoryError(this.message);
}
