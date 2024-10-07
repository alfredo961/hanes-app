import 'package:flutter/material.dart';

import '../models/hilo_model.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Hilo> myProducts = List<Hilo>.generate(
      100,
      (i) => Hilo(
            codigo: '02191-000000-LG-$i',
            descripcion: 'DC SP 260-70/36 BLK TXT POLY $i',
            cantidadConos: (i % 30) + 1,
            total: (i % 30) * 4,
            categoria: 'Polyester',
            fotoHilo: 'https://hanes-images.s3.amazonaws.com/fotosHilos/19432-000000-LG.jpeg',
            fotoDescripcion: 'https://hanes-images.s3.amazonaws.com/fotosDescripcionesHilos/19432-000000-LG.jpeg',
          ));
  List<Hilo> filteredProducts = [];
  List<Hilo> selectedProducts = [];
  String query = '';
  Map<String, int> selectedQuantities = {};

  HomeViewModel() {
    filteredProducts = myProducts;
    for (var product in myProducts) {
      selectedQuantities[product.codigo] = 1;
    }
  }

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    filteredProducts = myProducts
        .where((product) =>
            product.descripcion.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void toggleSelection(Hilo hilo) {
    if (selectedProducts.contains(hilo)) {
      selectedProducts.remove(hilo);
    } else {
      selectedProducts.add(hilo);
    }
    notifyListeners();
  }

  void updateQuantity(String codigo, int quantity) {
    selectedQuantities[codigo] = quantity;
    notifyListeners();
  }

  void clearSelectedProducts() {
    selectedProducts.clear();
    notifyListeners();
  }
}
