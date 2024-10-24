import 'package:flutter/material.dart';
import 'package:hilaza/services/apis/yarn_api.dart';
import '../models/team_model.dart';
import '../models/yarn_model.dart';
import '../services/apis/print_api.dart';
import '../services/apis/search_by_category_api.dart';
import '../services/apis/team_api.dart';
class HomeViewModel extends ChangeNotifier {
  final List<Hilo> myProducts = [];
  List<Hilo> filteredProducts = [];
  List<Hilo> selectedProducts = [];
  String query = '';
  Map<String, int> selectedQuantities = {};
  bool isLoading = true;
  final YarnApi yarnApi = YarnApi();
  final TeamService teamService = TeamService();
  final SearchByCategoryApi searchByCategoryApi = SearchByCategoryApi();
  final PrintService printService = PrintService();

  List<Team> _teams = [];
  bool _isLoadingTeams = false;
  String? _selectedTeamName;
  int? _selectedTeamId;
  bool noResultsFound = false;

  List<Team> get teams => _teams;
  bool get isLoadingTeams => _isLoadingTeams;
  String? get selectedTeamName => _selectedTeamName;
  int? get selectedTeamId => _selectedTeamId;

  HomeViewModel() {
    initializeData();
  }

  Future<void> initializeData({Function(String)? onError}) async {
    try {
      final yarns = await yarnApi.fetchYarns();
      myProducts.addAll(yarns);
      filteredProducts = myProducts;
      for (var product in myProducts) {
        selectedQuantities[product.cod!] = 1;
      }
    } catch (e) {
      debugPrint('Error al cargar los datos: $e');
      if (onError != null) {
        onError(e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    fetchTeams();
  }

  Future<void> fetchCategories(String category) async {
    try {
      final categories = await searchByCategoryApi.fetchCategories(category);
      filteredProducts = categories
          .map((categoryResult) => Hilo.fromCategoryResult(categoryResult))
          .toList();
      noResultsFound = filteredProducts.isEmpty;
      notifyListeners();
    } catch (e) {
      debugPrint('Error al obtener las categorías: $e');
      noResultsFound = true;
      notifyListeners();
    }
  }

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    filteredProducts = myProducts
        .where((product) =>
            product.description!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    noResultsFound = filteredProducts.isEmpty;
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
    noResultsFound = false;
    notifyListeners();
  }

  Future<void> fetchTeams() async {
    _isLoadingTeams = true;
    notifyListeners();

    try {
      _teams = await teamService.fetchTeams();
    } catch (e) {
      debugPrint('Error al obtener los equipos: $e');
    } finally {
      _isLoadingTeams = false;
      notifyListeners();
    }
  }

  void selectTeam(String teamName, int teamId) {
    _selectedTeamName = teamName;
    _selectedTeamId = teamId;
    notifyListeners();
  }

  void clearTeamSelection() {
    _selectedTeamName = null;
    _selectedTeamId = null;
    notifyListeners();
  }


  Future<int> sendPrintRequest(String filePath) async {
    if (_selectedTeamId == null) {
      throw Exception('No se ha seleccionado ningún equipo');
    }

    try {
      return await printService.sendPrintRequest(filePath, _selectedTeamId!);
    } catch (e) {
      debugPrint('Error al enviar la impresión: $e');
      rethrow;
    }
  }
}
