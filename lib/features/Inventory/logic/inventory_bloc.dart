import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/inventory_repository.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository repo;

  InventoryBloc(this.repo) : super(InventoryInitial()) {
    on<LoadCabang>((event, emit) async {
      emit(InventoryLoading());
      try {
        final cabangs = await repo.fetchCabang();
        emit(InventoryLoaded(cabangs: cabangs, kategoris: [], items: []));
      } catch (e) {
        emit(InventoryError("Gagal load cabang: $e"));
      }
    });

    on<LoadKategori>((event, emit) async {
      emit(InventoryLoading());
      try {
        final kategoris = await repo.fetchKategori(event.idCabang);
        final current =
            state is InventoryLoaded ? state as InventoryLoaded : null;
        emit(
          InventoryLoaded(
            cabangs: current?.cabangs ?? [],
            kategoris: kategoris,
            items: current?.items ?? [],
          ),
        );
      } catch (e) {
        emit(InventoryError("Gagal load kategori: $e"));
      }
    });

    on<LoadItems>((event, emit) async {
      emit(InventoryLoading());
      try {
        final items = await repo.fetchItems(
          event.idCabang,
          event.checkCondiment,
          event.keySortir,
          event.descending,
        );
        final current =
            state is InventoryLoaded ? state as InventoryLoaded : null;
        emit(
          InventoryLoaded(
            cabangs: current?.cabangs ?? [],
            kategoris: current?.kategoris ?? [],
            items: items,
          ),
        );
      } catch (e) {
        emit(InventoryError("Gagal load item: $e"));
      }
    });
  }
}
