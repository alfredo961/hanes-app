import 'package:flutter/material.dart';
import '../../models/fotos_hilos.dart';
import '../../models/yarn_model.dart';

class ProductSearchDelegate extends SearchDelegate<Hilo> {
  final List<Hilo> products;
  final List<Hilo> filteredProducts;

  ProductSearchDelegate(this.products, this.filteredProducts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(
            context,
            Hilo(
              cod: '',
              item: '',
              description: '',
              vendor: '',
              yarnType: '',
              fotosHilos: FotosHilos(nombre: '', ruta: ''),
              fotosDescripcionesHilos: FotosHilos(nombre: '', ruta: ''),
            ));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = filteredProducts
        .where((product) =>
            product.description!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron resultados',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final hilo = results[index];
        return ListTile(
          leading:
              hilo.fotosHilos?.ruta != null && hilo.fotosHilos!.ruta!.isNotEmpty
                  ? Image.network(hilo.fotosHilos!.ruta!,
                      width: 50, height: 50, fit: BoxFit.cover)
                  : Image.asset('assets/placeholder.png',
                      width: 50, height: 50, fit: BoxFit.cover),
          title: Text(hilo.description ?? 'No Description'),
          subtitle: Text('Código: ${hilo.cod}\nVendor: ${hilo.vendor}'),
          onTap: () {
            close(context, hilo);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((product) =>
            product.description!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (suggestions.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron resultados',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final hilo = suggestions[index];
        return ListTile(
          leading:
              hilo.fotosHilos?.ruta != null && hilo.fotosHilos!.ruta!.isNotEmpty
                  ? Image.network(hilo.fotosHilos!.ruta!,
                      width: 50, height: 50, fit: BoxFit.cover)
                  : Image.asset('assets/placeholder.png',
                      width: 50, height: 50, fit: BoxFit.cover),
          title: Text(hilo.description ?? 'No Description'),
          subtitle: Text('Código: ${hilo.cod}\nVendor: ${hilo.vendor}'),
          onTap: () {
            query = hilo.description!;
            showResults(context);
          },
        );
      },
    );
  }
}
