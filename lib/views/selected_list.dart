import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_viewmodel.dart';

class SelectedItemsList extends StatelessWidget {
  const SelectedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Hilos Seleccionados',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: viewModel.selectedProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No hay elementos para mostrar',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Para continuar, debe agregar nuevamente elementos a la lista.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    viewModel.clearSelectedProducts();
                  },
                  label: const Text(
                    'Eliminar todos los elementos de la lista',
                    style: TextStyle(color: Colors.red),
                  ),
                  icon: const Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.selectedProducts.length,
                    itemBuilder: (context, index) {
                      final hilo = viewModel.selectedProducts[index];
                      return Dismissible(
                        key: ValueKey(hilo.codigo),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          viewModel.toggleSelection(hilo);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(hilo.fotoHilo,
                                  width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            title: Text(
                              hilo.descripcion,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Código: ${hilo.codigo}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: viewModel.selectedProducts.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Acción para continuar
              },
              child: const Icon(CupertinoIcons.arrow_right),
            ),
    );
  }
}
