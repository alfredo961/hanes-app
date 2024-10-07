import 'package:flutter/material.dart';

import '../../models/hilo_model.dart';

class ProductSearchDelegate extends SearchDelegate<Hilo> {
  final List<Hilo> products;

  ProductSearchDelegate(this.products);

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
      close(context, Hilo(
        codigo: '',
        descripcion: '',
        cantidadConos: 0,
        total: 0,
        categoria: '',
        fotoHilo: '',
        fotoDescripcion: '',
      ));
    },
  );
}

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where((product) => product.descripcion.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final hilo = results[index];
        return ListTile(
          leading: Image.asset(hilo.fotoHilo),
          title: Text(hilo.descripcion),
          subtitle: Text('Código: ${hilo.codigo}\nCantidad de conos: ${hilo.cantidadConos}'),
          onTap: () {
            close(context, hilo);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products.where((product) => product.descripcion.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final hilo = suggestions[index];
        return ListTile(
          leading: Image.asset(hilo.fotoHilo),
          title: Text(hilo.descripcion),
          subtitle: Text('Código: ${hilo.codigo}\nCantidad de conos: ${hilo.cantidadConos}'),
          onTap: () {
            query = hilo.descripcion;
            showResults(context);
          },
        );
      },
    );
  }
}
