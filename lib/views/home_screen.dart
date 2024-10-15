import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/yarn_model.dart';
import '../viewmodels/home_viewmodel.dart';
import 'selected_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildImage(String? imageUrl) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(imageUrl, width: 80, height: 100, fit: BoxFit.cover)
        : Image.asset('assets/placeholder.png', width: 80, height: 100, fit: BoxFit.cover);
  }

  Widget _buildHiloDetails(BuildContext context, Hilo hilo) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Detalles del Hilo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            _buildImage(hilo.fotosHilos?.ruta),
            const SizedBox(height: 10),
            Text('Código: ${hilo.cod}', style: const TextStyle(fontSize: 18)),
            Text('Descripción: ${hilo.description}', style: const TextStyle(fontSize: 18)),
            Text('Vendor: ${hilo.vendor}', style: const TextStyle(fontSize: 18)),
            Text('Tipo de hilo: ${hilo.yarnType}', style: const TextStyle(fontSize: 18)),
            _buildImage(hilo.fotosDescripcionesHilos?.ruta),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            )
          ],
        ),
      ),
    );
  }

  void showHiloDetails(BuildContext context, Hilo hilo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => _buildHiloDetails(context, hilo),
    );
  }

  Widget _buildProductListTile(BuildContext context, Hilo hilo, HomeViewModel viewModel) {
    return Card(
      key: ValueKey(hilo.cod),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildImage(hilo.fotosHilos?.ruta),
        ),
        title: Text(hilo.description ?? 'No Description'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${hilo.cod}'),
            const Text('Cantidad de conos:'),
            DropdownButton<int>(
              value: viewModel.selectedQuantities[hilo.cod] ?? 1,
              items: List.generate(30, (i) => i + 1) // Assuming a max of 30 cones
                  .map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  viewModel.updateQuantity(hilo.cod!, newValue);
                }
              },
            ),
          ],
        ),
        trailing: Checkbox(
          value: viewModel.selectedProducts.contains(hilo),
          onChanged: (bool? value) {
            viewModel.toggleSelection(hilo);
          },
        ),
        onTap: () => showHiloDetails(context, hilo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Inicio',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: viewModel.updateSearchQuery,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar productos...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIconColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : ListView.builder(
                    itemCount: viewModel.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final hilo = viewModel.filteredProducts[index];
                      return _buildProductListTile(context, hilo, viewModel);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelectedItemsList()),
          );
        },
        tooltip: 'Siguiente',
        child: const Icon(CupertinoIcons.arrow_right),
      ),
    );
  }
}