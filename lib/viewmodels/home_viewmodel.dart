import 'package:flutter/material.dart';
import '../models/yarn_model.dart';
import '../services/http_services.dart';
import '../utils/constants.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Hilo> myProducts = [];
  List<Hilo> filteredProducts = [];
  List<Hilo> selectedProducts = [];
  String query = '';
  Map<String, int> selectedQuantities = {};
  bool isLoading = true;
  final CustomHttp customHttp = CustomHttp();

  HomeViewModel() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final data = await customHttp.get('/${Consts.getHilos}');
      myProducts.addAll((data as List).map((item) => Hilo.fromJson(item)).toList());
      filteredProducts = myProducts;
      for (var product in myProducts) {
        selectedQuantities[product.cod!] = 1;
      }
    } catch (e) {
      debugPrint('Error al cargar los datos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    filteredProducts = myProducts
        .where((product) =>
            product.description!.toLowerCase().contains(query.toLowerCase()))
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

  void updateQuantity(String cod, int quantity) {
    selectedQuantities[cod] = quantity;
    notifyListeners();
  }

  void clearSelectedProducts() {
    selectedProducts.clear();
    notifyListeners();
  }

  void resetValues() {
    filteredProducts = myProducts;
    selectedProducts.clear();
    query = '';
    selectedQuantities = {for (var product in myProducts) product.cod!: 1};
    isLoading = false;
    notifyListeners();
  }
}