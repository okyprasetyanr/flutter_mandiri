// screen_inventory.dart (REFRACTOR - Bloc friendly; UI preserved)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/features/Inventory/logic/inventory_bloc.dart';
import 'package:flutter_mandiri/features/Inventory/logic/inventory_event.dart';
import 'package:flutter_mandiri/features/Inventory/logic/inventory_state.dart';
import 'package:flutter_mandiri/function/function.dart';
import 'package:flutter_mandiri/model_data/model_cabang.dart';
import 'package:flutter_mandiri/model_data/model_item.dart';
import 'package:flutter_mandiri/model_data/model_kategori.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/template_responsif/layout_top_bottom_standart.dart';
import 'package:flutter_mandiri/widget/widget_navigation_gesture.dart';
import 'package:flutter_mandiri/widget/widget_snack_bar.dart';
import 'package:uuid/uuid.dart';

class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  // --- UI controllers & small local UI state (keperluan tampilan) ---
  TextEditingController search = TextEditingController();
  TextEditingController namaItemController = TextEditingController();
  TextEditingController hargaItemController = TextEditingController();
  TextEditingController kodeBarcodeController = TextEditingController();
  TextEditingController namaKategoriController = TextEditingController();

  PageController pageControllerTop = PageController();
  PageController pageControllerBottom = PageController();

  // small local UI state kept here (not lists)
  String? selectedfilter;
  String? selectedcabang; // display name (keperluan text field)
  String? selectedIDcabang; // id cabang terpilih
  String? selectedkategori; // nama kategori terpilih (display)
  String? selectedIdkategori; // id kategori terpilih
  String? selectedstatus;
  String? iditemUpdate;
  String? idkategoriUpdate;
  bool isOpen = false;
  bool checkcondiment = false;
  bool condiment = false;
  bool currentPage = true;
  int gridviewcount = 4;

  Map<String, bool> sortir = {'nama_item': true, 'qty_item': true};
  String keySortir = "nama_item";

  final List<String> status = ["Active", "Deactive"];
  final List<String> filter = ["A-Z", "Z-A", "Stock -", "Stock +"];

  // ------------------

  @override
  void initState() {
    super.initState();
    // dispatch initial load via Bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pastikan InventoryBloc sudah disediakan lebih tinggi (via BlocProvider)
      final bloc = context.read<InventoryBloc>();
      bloc.add(LoadCabang());
    });
    _gotoPage(currentPage);
  }

  @override
  void dispose() {
    search.dispose();
    namaItemController.dispose();
    hargaItemController.dispose();
    kodeBarcodeController.dispose();
    namaKategoriController.dispose();
    pageControllerTop.dispose();
    pageControllerBottom.dispose();
    super.dispose();
  }

  void _gotoPage(bool page) {
    int goto = page ? 0 : 1;
    setState(() {
      currentPage = page;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageControllerTop.hasClients && pageControllerBottom.hasClients) {
        pageControllerTop.animateToPage(
          goto,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        pageControllerBottom.animateToPage(
          goto,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Helper to request items load with current settings (cab, condiment, sort)
  void _requestLoadItems(String idCabang) {
    final bloc = context.read<InventoryBloc>();
    bloc.add(
      LoadItems(idCabang, checkcondiment, keySortir, sortir[keySortir] ?? true),
    );
  }

  // Helper to request kategori load for cabang
  void _requestLoadKategori(String idCabang) {
    final bloc = context.read<InventoryBloc>();
    bloc.add(LoadKategori(idCabang));
  }

  // Helper to request cabang re-load (e.g. after save)
  void _requestLoadCabang() {
    context.read<InventoryBloc>().add(LoadCabang());
  }

  // reset form fields (keperluan UI)
  void _resetFields() {
    iditemUpdate = null;
    idkategoriUpdate = null;
    namaItemController.clear();
    hargaItemController.clear();
    kodeBarcodeController.clear();
    // jangan panggil _initItem() lagi — gunakan bloc
    if (selectedIDcabang != null) {
      _requestLoadItems(selectedIDcabang!);
    }
  }

  // ---------- BUILD UI (layout preserved) ----------
  @override
  Widget build(BuildContext context) {
    // keep grid count as original
    gridviewcount = 4;

    return LayoutTopBottom(
      widgetTop: topLayout(),
      widgetBottom: bottomLayout(),
      widgetNavigation: navigationGesture(),
    );
  }

  // ---------- TOP LAYOUT (UI preserved, data come from state via BlocBuilder) ----------
  Widget topLayout() {
    return Column(
      children: [
        // first row (Menu button + switch page)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 130,
              margin: const EdgeInsets.only(top: 5),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isOpen = true;
                  });
                },
                label: Text("Menu", style: lv1TextStyleWhite),
                icon: const Icon(Icons.menu),
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.white,
                  elevation: 4,
                  backgroundColor: AppColor.primary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _gotoPage(!currentPage);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 150,
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                height: 55,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      curve: Curves.easeInOut,
                      left: currentPage ? -200 : 18,
                      top: 4,
                      duration: const Duration(milliseconds: 500),
                      child: rowContentAnim(
                        const Icon(Icons.swap_horiz_rounded, size: 35),
                        Text("Kategori", style: titleTextStyle),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeInOut,
                      left: currentPage ? 0 : 300,
                      top: 4,
                      duration: const Duration(milliseconds: 500),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: rowContentAnim(
                          const Icon(Icons.swap_horiz_rounded, size: 35),
                          Text("Inventori", style: titleTextStyle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // the main page content (kept PageView as original)
        Expanded(
          child: PageView(
            controller: pageControllerTop,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // ------------------- PAGE: Inventory (grid + filters) -------------------
              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Search textfield (keperluan UI; behavior unchanged)
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: search,
                          style: lv1TextStyle,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            labelText: "Search",
                            labelStyle: labelTextStyle,
                            hint: Text("Search...", style: lv1TextStyle),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Condiment toggle button (keperluan UI)
                      Flexible(
                        fit: FlexFit.loose,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              checkcondiment ? AppColor.primary : Colors.white,
                            ),
                            elevation: WidgetStateProperty.all(4),
                            padding: WidgetStatePropertyAll(
                              const EdgeInsets.all(15),
                            ),
                          ),
                          onPressed: () {
                            // toggle local UI state and request reload via Bloc
                            setState(() {
                              checkcondiment = !checkcondiment;
                            });
                            if (selectedIDcabang != null) {
                              _requestLoadItems(selectedIDcabang!);
                            }
                          },
                          label: Text("Condiment", style: lv05TextStyle),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // filter row (Filter, Cabang dropdown, Status dropdown)
                  SizedBox(
                    height: 45,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),

                        // Filter dropdown (A-Z etc.) -> onChanged triggers reload
                        Expanded(
                          child: DropdownButtonFormField<dynamic>(
                            initialValue: selectedfilter,
                            style: lv05TextStyle,
                            hint: Text("Filter", style: lv1TextStyle),
                            items:
                                filter
                                    .map(
                                      (map) => DropdownMenuItem(
                                        value: map,
                                        child: Text(map),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              // keep local selectedfilter, update sorting keys, then reload
                              setState(() {
                                selectedfilter = value;
                                switch (value) {
                                  case "A-Z":
                                    keySortir = "nama_item";
                                    sortir[keySortir] = false;
                                    break;
                                  case "Z-A":
                                    keySortir = "nama_item";
                                    sortir[keySortir] = true;
                                    break;
                                  case "Stock -":
                                    keySortir = "qty_item";
                                    sortir[keySortir] = false;
                                    break;
                                  case "Stock +":
                                    keySortir = "qty_item";
                                    sortir[keySortir] = true;
                                    break;
                                  default:
                                    keySortir = "nama_item";
                                }
                              });
                              if (selectedIDcabang != null) {
                                _requestLoadItems(selectedIDcabang!);
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        // --- CABANG dropdown: data from Bloc state (use BlocBuilder) ---
                        Expanded(
                          flex: 2,
                          child: BlocBuilder<InventoryBloc, InventoryState>(
                            builder: (context, state) {
                              if (state is InventoryLoaded &&
                                  state.cabangs.isNotEmpty) {
                                // ensure selectedIDcabang kept if present
                                final valueToShow = state.cabangs.firstWhere(
                                  (c) => c.getidCabang == selectedIDcabang,
                                  orElse: () {
                                    // if no selected, choose the first cabang and trigger kategori+items
                                    WidgetsBinding.instance.addPostFrameCallback((
                                      _,
                                    ) {
                                      if (selectedIDcabang == null) {
                                        selectedIDcabang =
                                            state.cabangs.first.getidCabang;
                                        selectedcabang =
                                            state.cabangs.first.getdaerahCabang;
                                        // request kategori & items for this cabang
                                        _requestLoadKategori(selectedIDcabang!);
                                        _requestLoadItems(selectedIDcabang!);
                                      }
                                    });
                                    return state.cabangs.first;
                                  },
                                );

                                return DropdownButtonFormField<ModelCabang>(
                                  value: valueToShow,
                                  style: lv05TextStyle,
                                  hint: Text(
                                    selectedcabang ?? "Cabang",
                                    style: lv1TextStyle,
                                  ),
                                  items:
                                      state.cabangs
                                          .map(
                                            (map) => DropdownMenuItem(
                                              value: map,
                                              child: Text(map.getdaerahCabang),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      // update local display vars and request new data via Bloc
                                      setState(() {
                                        selectedcabang = value.getdaerahCabang;
                                        selectedIDcabang = value.getidCabang;
                                      });
                                      _requestLoadKategori(value.getidCabang);
                                      _requestLoadItems(value.getidCabang);
                                    }
                                  },
                                );
                              }
                              // while loading or empty show placeholder
                              if (state is InventoryLoading) {
                                return const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return DropdownButtonFormField<ModelCabang>(
                                style: lv05TextStyle,
                                hint: Text(
                                  selectedcabang ?? "Cabang",
                                  style: lv1TextStyle,
                                ),
                                items: const [],
                                onChanged: (_) {},
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Status dropdown (local only)
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            style: lv05TextStyle,
                            hint: const Text("Status"),
                            initialValue: selectedstatus,
                            items:
                                status
                                    .map(
                                      (map) => DropdownMenuItem(
                                        value: map,
                                        child: Text(map),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedstatus = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- GridView Items: data from Bloc state ---
                  Flexible(
                    fit: FlexFit.loose,
                    child: BlocBuilder<InventoryBloc, InventoryState>(
                      builder: (context, state) {
                        if (state is InventoryLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is InventoryLoaded) {
                          final items = state.items;
                          if (items.isEmpty) {
                            return const Center(child: Text("Belum ada item"));
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.all(5),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: gridviewcount,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 2 / 3,
                                ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final it = items[index];
                              return Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                elevation: 4,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    // fill form fields like original
                                    namaItemController.text = it.getnamaItem;
                                    hargaItemController.text = it.gethargaItem;
                                    kodeBarcodeController.text = it.getBarcode;
                                    iditemUpdate = it.getidItem;
                                    setState(() {
                                      selectedkategori =
                                          state.kategoris
                                              .firstWhere(
                                                (k) =>
                                                    k.getidKategori ==
                                                    it.getidKategoriItem,
                                                orElse:
                                                    () => ModelKategori(
                                                      namaKategori:
                                                          "Kategori...",
                                                      idkategori: "1",
                                                    ),
                                              )
                                              .getnamaKategori;
                                      selectedIdkategori = it.getidKategoriItem;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Center(
                                            child: Image.asset(
                                              "assets/logo.png",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                          child: Text(
                                            it.getnamaItem,
                                            style: lv05TextStyle,
                                          ),
                                        ),
                                        Text(
                                          formatUang(it.gethargaItem),
                                          style: lv05TextStyle,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("Qty", style: lv05TextStyle),
                                            Text(
                                              formatQty(it.getqtyitem),
                                              style: lv0TextStyleRED,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is InventoryError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),

              // ------------------- PAGE: Kategori (right page) -------------------
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 150,
                    child: BlocBuilder<InventoryBloc, InventoryState>(
                      builder: (context, state) {
                        if (state is InventoryLoaded &&
                            state.cabangs.isNotEmpty) {
                          // show cabang dropdown similar to top
                          return DropdownButtonFormField<ModelCabang>(
                            style: lv05TextStyle,
                            initialValue: state.cabangs.firstWhere(
                              (c) => c.getidCabang == selectedIDcabang,
                              orElse: () => state.cabangs.first,
                            ),
                            hint: Text(
                              selectedcabang ?? "Cabang",
                              style: lv05TextStyle,
                            ),
                            items:
                                state.cabangs
                                    .map(
                                      (map) => DropdownMenuItem(
                                        value: map,
                                        child: Text(map.getdaerahCabang),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedcabang = value.getdaerahCabang;
                                  selectedIDcabang = value.getidCabang;
                                });
                                _requestLoadItems(value.getidCabang);
                                _requestLoadKategori(value.getidCabang);
                              }
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<InventoryBloc, InventoryState>(
                      builder: (context, state) {
                        if (state is InventoryLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is InventoryLoaded) {
                          final kategoris = state.kategoris;
                          if (kategoris.isEmpty) {
                            return const Center(
                              child: Text("Belum ada kategori"),
                            );
                          }
                          return ListView.builder(
                            itemCount: kategoris.length,
                            itemBuilder: (context, index) {
                              final kat = kategoris[index];
                              return ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black,
                                      Colors.black,
                                      Colors.transparent,
                                    ],
                                    stops: [0, 0.02, 0.98, 1],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: Material(
                                  color:
                                      index % 2 == 0
                                          ? const Color.fromARGB(
                                            255,
                                            235,
                                            235,
                                            235,
                                          )
                                          : const Color.fromARGB(
                                            255,
                                            221,
                                            221,
                                            221,
                                          ),
                                  child: InkWell(
                                    onTap: () {
                                      namaKategoriController.text =
                                          kat.getnamaKategori;
                                      idkategoriUpdate = kat.getidKategori;
                                      setState(() {
                                        selectedIdkategori = kat.getidKategori;
                                        selectedkategori = kat.getnamaKategori;
                                      });
                                    },
                                    onLongPress: () {
                                      // keep original guidance: long press to delete (you may handle via bloc event)
                                      // Example: dispatch DeleteKategori event if implemented
                                      // context.read<InventoryBloc>().add(DeleteKategori(kat.getidKategori));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        kat.getnamaKategori,
                                        style: lv1TextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is InventoryError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- BOTTOM LAYOUT (form area) ----------
  Widget bottomLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 250,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              height: 60,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    curve: Curves.easeInOut,
                    right: currentPage ? -250 : 0,
                    top: 4,
                    duration: const Duration(milliseconds: 500),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        namaKategoriController.clear();
                        idkategoriUpdate = null;
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      icon: const Icon(Icons.restart_alt_rounded, size: 25),
                      label: Text("Detail Kategori", style: titleTextStyle),
                    ),
                  ),
                  AnimatedPositioned(
                    curve: Curves.easeInOut,
                    right: currentPage ? 0 : 350,
                    top: 4,
                    duration: const Duration(milliseconds: 500),
                    child: ElevatedButton.icon(
                      onPressed: _reset,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      icon: const Icon(Icons.restart_alt_rounded, size: 25),
                      label: Text("Detail Item", style: titleTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: PageView(
            reverse: true,
            controller: pageControllerBottom,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // ------------------ Item detail form (left) ------------------
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 0,
                ),
                children: [
                  customTextField("Nama Item", namaItemController),
                  const SizedBox(height: 10),
                  customTextField("Kode/Barcode", kodeBarcodeController),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: customTextField("Harga", hargaItemController),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: GestureDetector(
                          onTap: () => setState(() => condiment = !condiment),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 135,
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color:
                                  condiment ? AppColor.primary : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: (condiment
                                          ? Colors.black
                                          : Colors.green)
                                      .withOpacity(0.4),
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  left: condiment ? -50 : 5,
                                  duration: const Duration(milliseconds: 500),
                                  child: const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 25,
                                  ),
                                ),
                                AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  left: condiment ? 100 : 150,
                                  duration: const Duration(milliseconds: 500),
                                  child: const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  top: 2,
                                  left: condiment ? -100 : 38,
                                  duration: const Duration(milliseconds: 500),
                                  child: Text("Normal", style: lv1TextStyle),
                                ),
                                AnimatedPositioned(
                                  curve: Curves.easeInOut,
                                  left: condiment ? 10 : 150,
                                  top: 2,
                                  duration: const Duration(milliseconds: 500),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Condiment",
                                      style: lv1TextStyleWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Kategori & Cabang: kategori from state; cabang displayed as disabled textfield (value from selectedcabang)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<InventoryBloc, InventoryState>(
                            builder: (context, state) {
                              if (state is InventoryLoaded &&
                                  state.kategoris.isNotEmpty) {
                                return DropdownButtonFormField<ModelKategori>(
                                  style: lv05TextStyle,
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    label: Text("Pilih Kategori"),
                                  ),
                                  initialValue: state.kategoris.firstWhere(
                                    (k) =>
                                        k.getidKategori == selectedIdkategori,
                                    orElse: () => state.kategoris.first,
                                  ),
                                  hint: Text(
                                    selectedkategori ?? "Kategori..",
                                    style: lv1TextStyle,
                                  ),
                                  items:
                                      state.kategoris
                                          .map(
                                            (map) =>
                                                DropdownMenuItem<ModelKategori>(
                                                  value: map,
                                                  child: Text(
                                                    map.getnamaKategori,
                                                  ),
                                                ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedkategori =
                                            value.getnamaKategori;
                                        selectedIdkategori =
                                            value.getidKategori;
                                      });
                                    }
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: lv1TextStyleDisable,
                            enabled: false,
                            controller: TextEditingController(
                              text: selectedcabang ?? "",
                            ),
                            decoration: const InputDecoration(
                              labelText: "Cabang",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Delete + Save buttons (Save will push data to Firestore and then ask bloc to reload)
                  SizedBox(
                    height: 55,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Hapus: you can dispatch bloc event DeleteItem if implemented
                              if (iditemUpdate != null) {
                                // example: context.read<InventoryBloc>().add(DeleteItem(iditemUpdate!));
                                // For backward compatibility, call ModelItem.delete directly (if you prefer)
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(iditemUpdate)
                                    .delete();
                                _resetFields();
                                // reload via bloc
                                if (selectedIDcabang != null)
                                  _requestLoadItems(selectedIDcabang!);
                              } else {
                                customSnackBar(
                                  context,
                                  "Pilih item dulu untuk dihapus",
                                );
                              }
                            },
                            label: Text("Hapus", style: lv1TextStyleWhite),
                            icon: const Icon(Icons.delete, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: AppColor.delete,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (namaItemController.text.isEmpty ||
                                  hargaItemController.text.isEmpty ||
                                  kodeBarcodeController.text.isEmpty ||
                                  selectedIdkategori == null ||
                                  selectedIDcabang == null) {
                                customSnackBar(context, "Data belum lengkap!");
                                return;
                              }

                              String iditem =
                                  iditemUpdate == null
                                      ? const Uuid().v4()
                                      : iditemUpdate!;
                              final item = ModelItem(
                                uidUser: UserSession.ambilUidUser()!,
                                namaItem: namaItemController.text,
                                idItem: iditem,
                                hargaItem: hargaItemController.text,
                                idKategoriItem: selectedIdkategori!,
                                statusCondiment: condiment,
                                urlGambar: "",
                                qtyItem: 0,
                                idCabang: selectedIDcabang!,
                                barcode: kodeBarcodeController.text,
                              );

                              // Simpan ke Firestore (kamu bisa ubah ini jadi event AddItem jika sudah ada di bloc)
                              await item.pushORupdateData(iditem);
                              // reset form and reload via bloc
                              _resetFields();
                              if (selectedIDcabang != null)
                                _requestLoadItems(selectedIDcabang!);
                            },
                            label: Text("Simpan", style: lv1TextStyleWhite),
                            icon: const Icon(Icons.save, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: AppColor.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------ Kategori form (right) ------------------
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: customTextField(
                          "Nama Kategori",
                          namaKategoriController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          enabled: false,
                          controller: TextEditingController(
                            text: selectedcabang ?? "",
                          ),
                          decoration: const InputDecoration(
                            labelText: "Cabang",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (namaKategoriController.text.trim().isEmpty ||
                            selectedIDcabang == null) {
                          customSnackBar(
                            context,
                            "Nama kategori atau cabang belum dipilih",
                          );
                          return;
                        }
                        String idkategori =
                            idkategoriUpdate == null
                                ? const Uuid().v4()
                                : idkategoriUpdate!;
                        Map<String, dynamic> pushKategori = {
                          "nama_kategori": namaKategoriController.text.trim(),
                          "id_kategori": idkategori,
                          "uid_user": UserSession.ambilUidUser(),
                          "id_cabang": selectedIDcabang,
                        };
                        await FirebaseFirestore.instance
                            .collection("kategori")
                            .doc(idkategori)
                            .set(pushKategori);
                        namaKategoriController.clear();
                        idkategoriUpdate = null;
                        // reload kategori via bloc
                        if (selectedIDcabang != null)
                          _requestLoadKategori(selectedIDcabang!);
                      },
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.white,
                        backgroundColor: AppColor.primary,
                      ),
                      icon: const Icon(Icons.check),
                      label: Text("Simpan", style: lv1TextStyleWhite),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "PANDUAN:\nUntuk hapus Kategori, silahkan klik dan tahan Kategori yang diinginkan",
                        style: lv05TextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Navigation Gesture (UI as original) ----------
  Widget navigationGesture() {
    final contentNavGesture = [
      {
        "id": "inventory",
        "toContext": const ScreenInventory(),
        "text_menu": "Inventori",
        "onTap": () {},
      },
    ];

    return NavigationGesture(
      currentPage: "inventory",
      attContent: contentNavGesture,
      isOpen: isOpen,
      close: () {
        setState(() {
          isOpen = false;
        });
      },
    );
  }

  // ---------- small helpers ----------
  Widget customTextField(String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: lv05TextStyle,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(text, style: lv05TextStyle),
        hint: Text("$text...", style: lv05TextStyle),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget rowContentAnim(Icon iconContent, Text textCOntent) {
    return Row(children: [iconContent, textCOntent]);
  }

  Widget anim(
    bool swap,
    VoidCallback callback,
    Widget text1,
    Widget text2,
    double width,
    double height,
  ) {
    return GestureDetector(
      onTap: callback,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: width,
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        height: height,
        child: Stack(
          children: [
            AnimatedPositioned(
              curve: Curves.easeInOut,
              left: swap ? -width : 0,
              top: 4,
              duration: const Duration(milliseconds: 500),
              child: text2,
            ),
            AnimatedPositioned(
              curve: Curves.easeInOut,
              left: swap ? 0 : width + (width / 2),
              top: 4,
              duration: const Duration(milliseconds: 500),
              child: Align(alignment: Alignment.centerLeft, child: text1),
            ),
          ],
        ),
      ),
    );
  }

  // keep the original _reset to preserve end behavior (it used _initItem which now replaced by bloc requests)
  void _reset() async {
    iditemUpdate = null;
    idkategoriUpdate = null;
    namaItemController.clear();
    hargaItemController.clear();
    kodeBarcodeController.clear();
    if (selectedIDcabang != null) {
      _requestLoadItems(selectedIDcabang!);
    }
  }
}
