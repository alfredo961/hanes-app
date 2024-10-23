import 'package:flutter/material.dart';
import 'package:hilaza/utils/constants.dart';
import 'package:hilaza/views/widgets/elevated_button.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';

class SearchAndFilterBar extends StatefulWidget {
  const SearchAndFilterBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchAndFilterBarState createState() => _SearchAndFilterBarState();
}

class _SearchAndFilterBarState extends State<SearchAndFilterBar> {
  bool _isFilterVisible = false;
  String _selectedCategory = '';

  void _toggleFilterVisibility() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
  }

  void _applyFilter(HomeViewModel viewModel) {
    viewModel.fetchCategories(_selectedCategory);
    _toggleFilterVisibility();
  }

  void _clearFilter(HomeViewModel viewModel) {
    setState(() {
      _selectedCategory = '';
    });
    viewModel.resetValues();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: viewModel.updateSearchQuery,
                  style: const TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Buscar productos...',
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIconColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Consts.rojo),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isFilterVisible ? Icons.close : Icons.filter_list,
                  color: Colors.grey,
                ),
                onPressed: _toggleFilterVisibility,
              ),
            ],
          ),
        ),
        if (_isFilterVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Card(
              borderOnForeground: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filtrar por categorías',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        _buildFilterChip('Polyester'),
                        _buildFilterChip('Blend'),
                        _buildFilterChip('Cotton'),
                        _buildFilterChip('Spandex'),
                        _buildFilterChip('Ciclo'),
                        _buildFilterChip('Nylon'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainButton(
                          onPressed: () => _applyFilter(viewModel),
                          text: 'Aplicar filtro',
                        ),
                        TextButton(
                          onPressed: () => _clearFilter(viewModel),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Limpiar filtros'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (viewModel.noResultsFound)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No se encontraron resultados',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip(String category) {
    return FilterChip(
      label: Text(category),
      selected: _selectedCategory == category,
      onSelected: (bool selected) {
        setState(() {
          _selectedCategory = selected ? category : '';
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
