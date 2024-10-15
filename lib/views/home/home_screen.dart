import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hilaza/views/selected_list.dart';
import 'package:provider/provider.dart';

import '../../models/yarn_model.dart';
import '../../viewmodels/home_viewmodel.dart';
import 'hilo_details_widget.dart';
import 'product_list_tile.dart';
import 'search_and_filter_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showHiloDetails(BuildContext context, Hilo hilo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => HiloDetailsWidget(hilo: hilo),
    );
  }

  void _showErrorDialog(BuildContext context, String message, HomeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.initializeData(onError: (msg) => _showErrorDialog(context, msg, viewModel));
              },
              child: const Text('Reintentar'),
            ),
          ],
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
          const SearchAndFilterBar(),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : ListView.builder(
                    itemCount: viewModel.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final hilo = viewModel.filteredProducts[index];
                      return ProductListTile(
                        hilo: hilo,
                        viewModel: viewModel,
                        onTap: (hilo) => showHiloDetails(context, hilo),
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
