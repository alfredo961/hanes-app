import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hilo_model.dart';
import '../viewmodels/home_viewmodel.dart';
import 'selected_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showHiloDetails(BuildContext context, Hilo hilo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
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
                Image.network(hilo.fotoHilo),
                const SizedBox(height: 10),
                Text('Código: ${hilo.codigo}',
                    style: const TextStyle(fontSize: 18)),
                Text('Descripción: ${hilo.descripcion}',
                    style: const TextStyle(fontSize: 18)),
                Text('Cantidad de conos: ${hilo.cantidadConos}',
                    style: const TextStyle(fontSize: 18)),
                Text('Total: ${hilo.total}',
                    style: const TextStyle(fontSize: 18)),
                Text('Categoría: ${hilo.categoria}',
                    style: const TextStyle(fontSize: 18)),
                Image.network(hilo.fotoDescripcion),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                )
              ],
            ),
          ),
        );
      },
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
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar productos...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.filteredProducts.length,
              itemBuilder: (context, index) {
                final hilo = viewModel.filteredProducts[index];
                return Card(
                  key: ValueKey(hilo.codigo),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: ListTile(
                    leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(hilo.fotoHilo, width: 50, height: 50, fit: BoxFit.cover),
                ),
                    title: Text(hilo.descripcion),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código: ${hilo.codigo}'),
                        const Text('Cantidad de conos:'),
                        DropdownButton<int>(
                          value: viewModel.selectedQuantities[hilo.codigo] ?? 1,
                          items: List.generate(hilo.cantidadConos, (i) => i + 1)
                              .map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              viewModel.updateQuantity(hilo.codigo, newValue);
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
