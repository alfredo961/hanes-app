import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hilaza/utils/constants.dart';
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
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: HiloDetailsWidget(hilo: hilo),
          ),
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: Consts.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Lista de hilos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .02,),
          Text('Teams: ${viewModel.selectedTeamName}'),
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
